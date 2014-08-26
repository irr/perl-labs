use strict;
use warnings;

use 5.014;

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

for my $thread (@threads) {
    my $data = $thread->join;
    say $data;
}
