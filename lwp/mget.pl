use strict;
use warnings;

use threads;

use LWP::UserAgent;
use JSON;

my $ua = LWP::UserAgent->new();
my @threads;

for my $url ('http://www.google.com/', 'http://www.perl.org/') {
    push @threads, async { 
        my $json = JSON->new->allow_nonref();
        my %hash = (url => $url);
        my $res = $ua->get($url);
        $hash{size} = length($res->content);
        return $json->encode(\%hash);
    };
}

my $json = JSON->new->allow_nonref();
my $data = [];

for my $thread (@threads) {
    push @$data, $json->decode($thread->join);
}

foreach my $h (@$data) {
    print "URL: $h->{url} has $h->{size} byte(s)\n";
}
