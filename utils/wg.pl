#!/usr/local/bin/perlbrew.sh

use 5.014;
use strict;
use warnings;

use Getopt::Long;

my $limit = 0;
my $timeout = 15;

GetOptions ('limit=i' => \$limit);
GetOptions ('timeout=i' => \$timeout);

if ($#ARGV < 0) {
    print "usage: wg.pl [--limit=k --timeout=s] <file>\n";
    exit 1;
}

my $target = $ARGV[0];

my $rate = ($limit > 0) ? "--limit-rate=".($limit * 1024) : "";

my $cmd = "wget -c --timeout=$timeout $rate ". 
          "--no-check-certificate --user=irr --password=0cean ".
          "https://ocean:8080/$target";

my $r;

do {
    print "downloading $target...\n";
    $r = system($cmd);
    if ($r) {
        print "retrying in $timeout seconds...\n";
        sleep $timeout;
    }    
} while ($r != 0);
