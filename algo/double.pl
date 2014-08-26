use strict;
use warnings;

sub NewList {
    return { N => 0, First => undef, Last => undef };
}

sub Remove {
    my ($ref, $node) = @_;
    return undef unless ($ref and $node);
    if ($node == $$ref{First} and $node == $$ref{Last}) {
        $$ref{First} = undef;
        $$ref{Last} = undef;
    } elsif ($node == $$ref{First}) {
        $$ref{First} = $$node{Next};
        ${$$ref{First}}{Prev} = undef;
    } elsif ($node == $$ref{Last}) {
        $$ref{Last} = $$node{Prev};
        ${$$ref{Last}}{Next} = undef;
    } else {
        my ($after, $before) = ($$node{Next}, $$node{Prev});
        ($$after{Prev}, $$before{Next}) = ($before, $after);
    }
    $$ref{N}--;
    return $$node{Data};
}

sub Push {
    my ($ref, $data) = @_;
    my $node = { Prev => undef, Next => undef, Data => $data };
    unless (%{$ref}{Last}) {
        $$ref{First} = $node;
        $$ref{Last} = $node;
        $$ref{N}++;
    } else {
        my $last = $$ref{Last};
        $$last{Next} = $node;
        $$node{Prev} = $last;
        $$ref{Last} = $node;
    }
    return $node;
}

sub Unshift {
    my ($ref, $data) = @_;
    my $node = { Prev => undef, Next => undef, Data => $data };
    unless (%{$ref}{First}) {
        $$ref{First} = $node;
        $$ref{Last} = $node;
        $$ref{N}++;
    } else {
        my $first = $$ref{First};
        $$first{Prev} = $node;
        $$node{Next} = $first;
        $$ref{First} = $node;
    }
    return $node;
}

sub Shift {
    my $ref = shift;
    return undef unless $$ref{First};
    my $data = ${$$ref{First}}{Data};
    &Remove($ref, $$ref{First});
    return $data;
}

sub Pop {
    my $ref = shift;
    return undef unless $$ref{Last};
    my $data = ${$$ref{Last}}{Data};
    &Remove($ref, $$ref{Last});
    return $data;
}

sub Dump {
    my $ref = shift;
    my ($i, $p) = (1, $$ref{First});
    while ($p) {
        print sprintf("%02d: %s\n", $i, $$p{Data});
        $p = $$p{Next};
        $i++;
    }
    print "<empty>\n" if $i == 1;
}

my $l = &NewList();
Dump($l);

for (my $i = 1; $i < 10; $i++) {
    Push($l, sprintf("data number %02d", $i));
}
Dump($l);

print Remove($l, ${$l}{Last}), "\n";
Dump($l);

print Shift($l), "\n";
Dump($l);

print Pop($l), "\n";
Dump($l);
