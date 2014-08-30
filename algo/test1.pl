use strict;
use warnings;

my %wc;

sub stickers {
    my $w = shift;
    my $max = 0;
    my %c;
    $c{$_}++ for split //, $w;
    foreach my $l (keys %c) {
        if ($l ne " ") { 
            my $diff = $c{$l} / $wc{$l};
            if ($diff > $max) {
                $max = $diff;
            }
            print "$l: $c{$l} $wc{$l} $diff\n";
        }
    }
    print "$w need $max sticker(s)\n";
}

$wc{$_}++ for split //, "facebook";

&stickers($_) for ("coffee kebab", "book", "ffacebook");


