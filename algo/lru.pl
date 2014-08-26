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
    } else {
        my $last = $$ref{Last};
        $$last{Next} = $node;
        $$node{Prev} = $last;
        $$ref{Last} = $node;
    }
    $$ref{N}++;
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
    print "LRU: $$ref{N}\nLink Data:\n";
    my ($i, $p) = (1, $$ref{Link}->{First});
    while ($p) {
        print sprintf("\t%02d: %s\n", $i, $$p{Data});
        $p = $$p{Next};
        $i++;
    }
    print "\t<empty>\n" if $i == 1;
    print "Hash Keys:\n\t";
    foreach (keys %{$$ref{Hash}}) {
        print "$_ ";
    }
    print "\n";
}

sub NewLRU {
    my $n = shift;
    return { N => $n, Link => &NewList(), Hash => undef };
}

sub Add {
    my ($ref, $k) = @_;
    if ($$ref{N} == $$ref{Link}->{N}) {
        my $id = Shift($$ref{Link});
        delete $$ref{Hash}->{$id};
    }
    &Delete($ref, $k);
    my $node = &Push($$ref{Link}, $k);
    $$ref{Hash}->{$k} = {Node => $node};
}

sub Delete {
    my ($ref, $k) = @_;
    my $data = $$ref{Hash}->{$k};
    if ($data) {
        &Remove($$ref{Link}, $data->{Node});
        delete $$ref{Hash}, $k;
    }
}

my $max = 5;
my $l = &NewLRU($max);

for (my $i = 0; $i < $max; $i++) {
    &Add($l, "Data$i");
}
&Dump($l);

&Add($l, "Data5");
&Dump($l);
