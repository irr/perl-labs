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
    my ($obj, $words) = @_;
    say "\nTesting $obj ( @{$words} )...";
    say Dump($b->query($words));
}

$b = Bayes->new({"classes" => ["Doyle", "Dowson", "Beowulf"]});

foreach ("Doyle", "Dowson", "Beowulf") {
    my @w = map { lc($_) } load("$_.txt");
    $b->learn($_, \@w);    
}

$b->freeze("f.bin");

test($b, ["adventures", "sherlock", "holmes"]);
test($b, ["comedy", "masks"]);
test($b, ["hrothgar", "beowulf"]);

$b = Bayes->fromfile({"file" => "f.bin"});

test($b, ["adventures", "sherlock", "holmes"]);
test($b, ["comedy", "masks"]);
test($b, ["hrothgar", "beowulf"]);

unlink("f.bin");