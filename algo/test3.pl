use strict;
use warnings;
use feature qw(say);

my $contents = "test test test test1 test1 test1 test2 test2 test2 test2 test3 test3 test3 test3";
my @words = (lc($contents) =~ /(\w+)/g);

my $counters = {};

$counters->{$_}++ foreach (@words);

my @toplist = reverse sort { $counters->{$a} <=> $counters->{$b} } (keys $counters);

say join(" ", @toplist);