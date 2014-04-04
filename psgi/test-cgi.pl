# start_server --port 127.0.0.1:5000 -- starman --workers 4 test-cgi.pl
# plackup -s Starman test-cgi.pl
# curl -s localhost:5000/|python -mjson.tool

use CGI::PSGI;

use JSON;
use Scalar::Util qw(reftype);

my $app = sub {
    my $env = shift;
    my $q = CGI::PSGI->new($env);

    my @filtered_keys = grep { reftype(\$env->{$_}) eq 'SCALAR' } keys %$env;
    my %filtered_hash = map { $_ => $env->{$_} } grep { exists $env->{$_} } @filtered_keys;
    
    my $json = JSON->new->allow_nonref();
    my $body = $json->encode(\%filtered_hash) . "\n";

    if ($env->{PATH_INFO} eq '/') {
        return [ $q->psgi_header('application/json'), [ $body ] ];
    } elsif ($env->{PATH_INFO} eq '/uol.jpg') {
        open my $fh, "<:raw", "/home/irocha/perl/psgi/uol.jpg" or die $!;
        return [ 200, ['Content-Type' => 'image/jpeg'], $fh ];
    } else {
        my ($status_code, $headers_aref) = $q->psgi_header('application/json');
        return [ (404, $headers_aref), [ ] ];
    }
};
