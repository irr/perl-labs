# start_server --port 127.0.0.1:5000 -- starman --workers 4 server.pl
# ./server.pl -E production -s Starman -o 0.0.0.0 -p 5000 --workers 4
# curl -s localhost:5000/|python -mjson.tool

use Plack::Middleware::AccessLog;

use JSON;
use Scalar::Util qw(reftype);

my $app = Plack::Middleware::AccessLog->wrap(sub {
    my $env = shift;
    
    my @filtered_keys = grep { reftype(\$env->{$_}) eq 'SCALAR' } keys %$env;
    my %filtered_hash = map { $_ => $env->{$_} } grep { exists $env->{$_} } @filtered_keys;
    
    my $json = JSON->new->allow_nonref();
    my $body = $json->encode(\%filtered_hash) . "\n";

    if ($env->{PATH_INFO} eq '/') {
        return [ 200, [ 'Content-Type' => 'application/json' ], [ $body ] ];
    } elsif ($env->{PATH_INFO} eq '/uol.jpg') {
        open my $fh, "<:raw", "/home/irocha/perl/psgi/uol.jpg" or die $!;
        return [ 200, ['Content-Type' => 'image/jpeg'], $fh ];
    } else {
        return [ 404, [ 'Content-Type' => 'application/json' ], [ $body ] ];
    }
}, format => "combined");

unless (caller) {
    require Plack::Runner;
    my $runner = Plack::Runner->new;
    $runner->parse_options(@ARGV);
    return $runner->run($app);
}

return $app;
