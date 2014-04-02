#!/usr/bin/env perl

use strict;
use warnings;

sub trim { 
    my $s = shift; 
    $s =~ s/^\s+|\s+$//g; 
    return $s 
};

sub readfile {
    my ($enc, $fname) = @_;
    if ($enc ne "utf-8") {
        return qx|iconv -f $enc -t UTF-8//TRANSLIT "$fname"|;
    }
    open(my $fh_in, "<", $fname);
    my @subs = <$fh_in>;
    close $fh_in;
    return @subs;
}

if ($#ARGV < 0) {
    print "usage: srt.pl <file>\n";
    exit 1;
}

my $file = &trim(qx|file -bi "$ARGV[0]"|);

my @encoding = split("charset=", $file);
exit(1) if @encoding == 1;

print "Original encoding: @encoding\n";
my @res = &readfile($encoding[1], $ARGV[0]);
exit(1) if $? != 0;

print "Translating and converting... ";

open(my $fh_out, ">", $ARGV[0]);
my $srt = join '', @res;
$srt =~ s/<.*?i>|<.*?b>|<.*?u>//gi;
print $fh_out $srt;
close($fh_out);

print "Ok!\n";
