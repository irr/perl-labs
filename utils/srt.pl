#!/usr/local/bin/perlbrew.sh

use strict;
use warnings;

use Encode qw(encode);
use Encode::Detect::Detector;

if ($#ARGV < 0) {
    print "usage: srt.pl <file>\n";
    exit 1;
}

open(my $fh_in, $ARGV[0]) or die $!;
binmode($fh_in);
my @sub = <$fh_in>;
close($fh_in);

my $encoding = Encode::Detect::Detector::detect("@sub");

open(my $fh_out, ">$ARGV[0]") or die $!;
foreach my $line (@sub) {
    $line =~ s/<.*?i>|<.*?b>|<.*?u>//gi;
    print $fh_out (($encoding ne "UTF-8") && encode("UTF-8", $line) || $line);    
}
close($fh_out);