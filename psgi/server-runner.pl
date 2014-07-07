#!/usr/bin/env perl

# pp -M Plack::Handler::Standalone -M Plack::Loader -M Plack::Middleware::Lint -M Plack::Middleware::StackTrace -M Plack::Handler::Starman -M IO::Socket::SSL -M Log::Dispatch::Syslog -B -o test server-runner.pl 
# ./test -E production -s Starman -o 0.0.0.0 -p 5000 --workers 4
# curl -s localhost:5000/|python -mjson.tool
# ./test -E production -s Starman -o 0.0.0.0 -p 5000 --workers 4 --enable-ssl --ssl-cert myirrlab.org.crt --ssl-key myirrlab.org.key
# curl -s -k https://localhost:5000/|python -mjson.tool

# start_server --port 127.0.0.1:5000 -- starman --workers 4 server.pl
# ./server.pl -E production -s Starman -o 0.0.0.0 -p 5000 --workers 4
# curl -s http://localhost:5000/|python -mjson.tool

use Plack::Middleware::AccessLog;
use Plack::Middleware::LogDispatch;

use JSON;
use Log::Dispatch;
use Scalar::Util qw(reftype);

my $logger = Log::Dispatch->new(
    outputs => [
        [
            'Syslog',
            min_level => 'info',
            ident     => 'server (starman)'
        ]
    ]
);

my $app = Plack::Middleware::AccessLog->wrap(sub {
    my $env = shift;
    
    my @filtered_keys = grep { reftype(\$env->{$_}) eq 'SCALAR' } keys %$env;
    my %filtered_hash = map { $_ => $env->{$_} } grep { exists $env->{$_} } @filtered_keys;
    
    my $json = JSON->new->allow_nonref();
    my $body = $json->encode(\%filtered_hash) . "\n";

    $env->{'psgix.logger'}->({ level => "info", message => "$env->{PATH_INFO} called" });

    if ($env->{PATH_INFO} eq '/') {
        return [ 200, [ 'Content-Type' => 'application/json' ], [ $body ] ];
    } elsif ($env->{PATH_INFO} eq '/uol.jpg') {
        open my $fh, "<:raw", "/home/irocha/perl/psgi/uol.jpg" or die $!;
        return [ 200, ['Content-Type' => 'image/jpeg'], $fh ];
    } else {
        return [ 404, [ 'Content-Type' => 'application/json' ], [ $body ] ];
    }
}, format => "combined");

$app = Plack::Middleware::LogDispatch->wrap($app, logger => $logger);

require Plack::Runner;
my $runner = Plack::Runner->new;
$runner->parse_options(@ARGV);
return $runner->run($app);
