#!/usr/bin/env perl

use 5.014;

use warnings;
use strict;

use Bayes;
use YAML;

sub load {
    my $file = shift;
    my $_ =`cat $file` or die $!;
    return /(\w+)/g;
}

sub test {
    my $words = shift;
    say "\nTesting ( @{$words} )...";
    say Dump($b->query($words));
}

$b = Bayes->new({"classes" => ["Doyle", "Dowson", "Beowulf"]});

foreach ("Doyle", "Dowson", "Beowulf") {
    my @w = map { lc($_) } load("$_.txt");
    $b->learn($_, \@w);    
}

test(["adventures", "sherlock", "holmes"]);
test(["comedy", "masks"]);
test(["hrothgar", "beowulf"]);