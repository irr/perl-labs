use strict;
use warnings;
use feature qw(say);

my $sticker  = "facebook";
my $counters = {};

sub ltrim { 
    my $s = shift; 
    $s =~ s/^\s+//; 
    return $s 
};
    
sub rtrim { 
    my $s = shift; 
    $s =~ s/\s+$//; 
    return $s
};
    
sub trim { 
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s
};

sub number_of_stickers {
    my ($counters, $word) = @_;
    my $letters = {}; 
    my $max = 0;
    $letters->{$_}++ foreach (split //, $word);
    foreach (keys %$letters) {
        my $n = $letters->{$_} / $counters->{$_};
        if ($n > $max) {
            $max = $n;
        }
    }
    return ($word, $max);
}

$counters->{$_}++ foreach (split //, $sticker);

open(my $fh, "<", "test.data");
while (<$fh>) {
    chomp(my $line = $_);
    if ($line =~ /(\w+)\|(\w+)$/) {
        my ($word, $n) = number_of_stickers($counters, $2);
        say $1,": ",$word, "=", $n;
    }
}
close($fh);

chomp(my $info = qx/uname -a/);
if ($info =~ /(\w+)\W+(\w+)\W+([\w|\.-]+)(.*?)$/) {
    $info = &trim($4);
    say "Type: $1\nHost: $2\nKernel: $3\nInfo: $info";
}