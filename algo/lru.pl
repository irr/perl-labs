use strict;
use warnings;

sub newList {
    return { N => 0, First => undef, Last => undef };
}

sub removeLink {
    my ($ref, $node) = @_;
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
    $node = {};
    $$ref{N}--;
}

sub pushLink {
    my ($ref, $node) = @_;
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
    return { N => $n, Link => &newList(), Hash => undef };
}

sub delLRU {
    my ($ref, $k) = @_;
    if (exists $$ref{Hash}->{$k}) {
        my $node = $$ref{Hash}->{$k};
        if ($node) {
            &removeLink($$ref{Link}, $node);
            delete $$ref{Hash}{$k};
        }
    }
}

sub Add {
    my ($ref, $k) = @_;
    &delLRU($ref, $k);
    my $node = &pushLink($$ref{Link}, { Prev => undef, Next => undef, Data => $k });
    $$ref{Hash}->{$k} = $node;
    if ($$ref{Link}->{N} > $$ref{N}) {
        my $id = $$ref{Link}->{First}->{Data};
        &delLRU($ref, $id);
    }
}

sub Get {
    my $ref = shift;
    if ($$ref{Link}->{Last}) {
        my $data = $$ref{Link}->{Last}->{Data};
        &delLRU($ref, $data);
        return $data;
    }
    return undef;
}

my $max = 5;
my $l = &NewLRU($max);

for (my $i = 0; $i < $max*2; $i++) {
    &Add($l, "Data$i");
}
&Dump($l);

my $data;

do {
    $data = &Get($l);
    print "$data\n" if $data;
} while ($data);

&Dump($l);
