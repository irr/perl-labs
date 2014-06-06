#!/usr/bin/env perl

# pp -o test test.pl 

use 5.014;

use warnings;
use strict;

use SSLAgent;
use JSON;

use Data::Dumper;

use constant SECURITY_ZONE => "ALESSANDRA";
use constant VLAN => 1024;

sub debug {
    my ($ua, $req, $content) = @_;
    my $res = $ua->request($req);
    say $req->method, " ", $req->uri, ": ", $res->status_line;
    say $res->content if $content;
    exit 1 unless ($res->is_success);
    return $res->content;
}

my $json = JSON->new->allow_nonref();

my $ua = SSLAgent->new();

my $data = '
{
    "name": "%s",
    "ipAddressPool":{
        "poolAddress":"10.0.0.3",
        "poolPrefix":"24",
    "prefix":"24"
},
"interfacePool":{
    "href":"/interface-pools/default-shared"
},
    "vlanId":"%d"
}';

say "Creating security-zone [", SECURITY_ZONE, "]";

my $req = HTTP::Request->new(POST => 'https://esm/api/esm/security-zones');
$req->content_type('application/json');
$req->content(sprintf($data, SECURITY_ZONE, VLAN));

debug($ua, $req);

say "Searching for security-zone [", SECURITY_ZONE, "]";

$req = HTTP::Request->new(GET => 'https://esm/api/esm/security-zones');
$data = debug($ua, $req);

my $ref = $json->decode($data);

foreach my $key (keys %{$ref}) {
    if ($key eq 'entries') {
        foreach my $entry (@{$ref->{entries}}) {
            if ($entry->{name} eq SECURITY_ZONE) {
                my $uri = $entry->{links}->[0]->{href};
                say "Found at [", $uri, "]";
                $req = HTTP::Request->new(DELETE => $uri);
                debug($ua, $req);
                say "Security-zone removed OK";           
            }
        }
    }
}