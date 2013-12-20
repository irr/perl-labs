#!/usr/local/bin/perlbrew.sh

use strict;
use warnings;

sub trim { 
    my $s = shift; 
    $s =~ s/^\s+|\s+$//g; 
    return $s 
};

if ($#ARGV < 0) {
    print "usage: srt.pl <file>\n";
    exit 1;
}

my $file = trim `file -bi $ARGV[0]`;

my @encoding = split "charset=", $file;

exit(1) if @encoding == 1;
exit(0) if $encoding[1] eq "utf-8";

my @res = `iconv -f $encoding[1] -t UTF-8//TRANSLIT $ARGV[0]`;

if ($? == 0) {
    open(my $fh_out, ">$ARGV[0]") or die $!;
    my $srt = join '', @res;
    $srt =~ s/<.*?i>|<.*?b>|<.*?u>//gi;
    print $fh_out $srt;
    close $fh_out;
}