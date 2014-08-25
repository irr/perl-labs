use strict;
use warnings;

use Data::Dumper;

sub NewBinHeap {
    return { List => [0] };
}

sub percUp {
    my $ref = shift;
    my $i = scalar @{$$ref{List}} - 1;
    while (int($i / 2) > 0) {
        if ($$ref{List}->[$i] < $$ref{List}->[int($i / 2)]) {
            ($$ref{List}->[$i], $$ref{List}->[int($i / 2)]) = 
                ($$ref{List}->[int($i / 2)], $$ref{List}->[$i]);
        }
        $i = int($i / 2);
    }
}

sub minChild {
    my ($ref, $i) = @_;
    my $size = scalar @{$$ref{List}} - 1;
    return $i * 2 if (($i*2 + 1) > $size);
    return $i * 2 if ($$ref{List}->[$i*2] < $$ref{List}->[$i*2+1]);
    return $i * 2 + 1;
}

sub percDown {    
    my $ref = shift;
    my $size = scalar @{$$ref{List}} - 1;
    my $i = 1;
    while (($i * 2) <= $size) {
        my $mc = &minChild($ref, $i);
        if ($$ref{List}->[$i] > $$ref{List}->[$mc]) {
            ($$ref{List}->[$i], $$ref{List}->[$mc]) = 
                ($$ref{List}->[$mc], $$ref{List}->[$i]);
        }
        $i = $mc;
    }
}

sub Insert {
    my ($ref, $elem) = @_;
    my $list = $$ref{List};
    push(@{$$ref{List}}, $elem);    
    percUp($ref);
}

sub Min {
    my $ref = shift;
    my $size = scalar @{$$ref{List}} - 1;
    if ($size < 1) {
        return undef
    }
    my $r = $$ref{List}->[1];
    if ($size > 1) {
        $$ref{List}->[1] = pop(@{$$ref{List}});
        percDown($ref);
    } else {
        pop(@{$$ref{List}});
    }
    return $r;
}

sub Dump {
    my $ref = shift;
    print Dumper($ref);
}

my $b = &NewBinHeap();
for (my $i = 50; $i > 0; $i -= 10) {
    &Insert($b, $i);
}

&Dump($b);

for (my $i = 1; $i < 8; $i++) {
    my $min = &Min($b);
    print "$min\n" if $min;
}

&Dump($b);
