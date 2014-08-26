use strict;
use warnings;

use Data::Dumper;

sub NewTree {
    return { Root => undef, N => 0 };
}

sub NewNode {
    my $data = shift;
    return { Data => $data, Left => undef, Right => undef };
}

sub insert {
    my ($node, $data) = @_;
    unless ($node) {
        return &NewNode($data);
    }
    if ($data lt $node->{Data}) {
        $node->{Left} = insert($node->{Left}, $data);
    } else {
        $node->{Right} = insert($node->{Right}, $data);
    }
    return $node;
}

sub Add {
    my ($tree, $data) = @_;
    my $node = &insert($tree->{Root}, $data);
    unless ($tree->{Root}) {
        $tree->{Root} = $node;
    }
    $tree->{N}++;
    return $node;
}


sub lookup {
    my ($node, $data) = @_;
    unless ($node) {
        return undef;
    }
    if ($data eq $node->{Data}) {
        return $node;
    } else {
        if ($data lt $node->{Data}) {
            return &lookup($node->{Left}, $data);
        } else {
            return &lookup($node->{Right}, $data);
        }
    }
}

sub Search {
    my ($tree, $data) = @_;
    return &lookup($tree->{Root}, $data);
}

sub minValue {
    my $p = shift;
    while ($p->{Left}) {
        $p = $p->{Left};
    }
    return $p;
}

sub remove {
     my ($tree, $node, $data) = @_;
     unless ($node) {
        return undef;
     }
     if ($data lt $node->{Data}) {
        $node->{Left} = &remove($tree, $node->{Left}, $data);
     } elsif ($data gt $node->{Data}) {
        $node->{Right} = &remove($tree, $node->{Right}, $data);
     } else {
        unless ($node->{Left}) {
            if ($node == $tree->{Root}) {
                $tree->{Root} = $node->{Right};
            }
            $tree->{N}--;
            return $node->{Right};
        } 
        unless ($node->{Right}) {
            if ($node == $tree->{Root}) {
                $tree->{Root} = $node->{Left};
            }
            $tree->{N}--;
            return $node->{Left};
        }
        my $p = &minValue($node->{Right});
        $node->{Data} = $p->{Data};
        $node->{Right} = &remove($tree, $node->{Right}, $p->{Data});
     }
     return $node;
}

sub Remove {
    my ($tree, $data) = @_;
    return &remove($tree, $tree->{Root}, $data);
}

sub dumpTreePreOrder {
    my $node = shift;
    unless ($node) {
        return
    }
    print "\t$node->{Data}\n";
    &dumpTreePreOrder($node->{Left});
    &dumpTreePreOrder($node->{Right});
}

sub dumpTreeInOrder {
    my $node = shift;
    unless ($node) {
        return
    }
    &dumpTreeInOrder($node->{Left});
    print "\t$node->{Data}\n";
    &dumpTreeInOrder($node->{Right});
}

sub dumpTreePostOrder {
    my $node = shift;
    unless ($node) {
        return
    }
    &dumpTreePostOrder($node->{Left});
    &dumpTreePostOrder($node->{Right});
    print "\t$node->{Data}\n";
}

sub Dump {
    my $tree = shift;
    unless ($tree->{Root}) {
        print "<empty>\n";
    }
    print "Tree: $tree->{N}\n";
    print "PreOrder:\n";
    &dumpTreePreOrder($tree->{Root});
    print "InOrder:\n";
    &dumpTreeInOrder($tree->{Root});
    print "PostOrder:\n";
    &dumpTreePostOrder($tree->{Root});
}

my $t = &NewTree();
my @v = ("ale", "irr", "luma", "lara", "babi");
&Add($t, $_) foreach (@v);
&Dump($t);

my $search = &Search($t, "irr");
print Dumper($search);

&Remove($t, "irr");
&Dump($t);

print Dumper($t);
