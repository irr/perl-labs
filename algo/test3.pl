use strict;
use warnings;
use feature qw(say);

my $contents = "test test test test1 test1 test1 test2 test2 test2 test2 test3 test3 test3 test3";
my @words = (lc($contents) =~ /(\w+)/g);

my $counters = {};
my @cwords = ();

foreach my $word (@words) {
    push @cwords, $word unless exists $counters->{$word};
    $counters->{$word}++;
}

my @toplist = reverse sort { $counters->{$a} <=> $counters->{$b} } @cwords;

say join(" ", @toplist);