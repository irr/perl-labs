#!/usr/bin/env perl

use strict; 
use warnings;

use List::MoreUtils qw( each_array );

my @k = qw(a a b c d d e e f);
my @v = qw(1 2 3 4 5 6 7 8 9);

my %h;
my $it = each_array(@k, @v);

while (my ($k, $v) = $it->()) {
    push @{ $h{ $k } }, $v;
}

use YAML;
print Dump \%h;
