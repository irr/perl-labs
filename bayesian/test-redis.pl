#!/usr/bin/env perl

use 5.014;

use warnings;
use strict;
use diagnostics;

use BayesRedis;
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

$b = BayesRedis->new(namespace => "bayes",
                     classes => ["good", "bad", "neutral"],
                     host => "127.0.0.1", 
                     port => 6379,
                     reconnect => 60);

$b->learn("good", ["tall", "handsome", "rich"]);
$b->learn("bad", ["bald", "poor", "ugly", "bitch"]);
$b->learn("neutral", ["none", "nothing", "maybe"]);

test($b, ["tall", "poor", "rich", "dummy", "nothing"]);

$b->quit;
