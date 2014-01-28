package Bayes;

use 5.014;

use warnings;
use strict;

use Data::MessagePack;

sub new {
    my $class = shift;
    my $self = { };
    bless $self, $class;
    die "missing required classes" unless $_[0]{classes};
    $self->{classes} = $_[0]{classes};
    foreach (@{$self->{classes}}) {
        $self->{sets}->{$_} = { freqs => {}, total => 0 };
    }
    return $self;
}

sub fromfile {
    my $class = shift;
    my $self = { };
    bless $self, $class;
    die "missing required file" unless $_[0]{file};
    $self->unfreeze($_[0]{file});
    return $self;
}

sub learn {
    my ($self, $class, $words) = @_;
    my $data = $self->{sets}->{$class};

    foreach (@{$words}) {
        $data->{freqs}->{$_} += 1;
        $data->{total}++;
    }    
}

sub query {
    my ($self, $words) = @_;
    my ($scores, $priors) = ({}, {});
    my $sum = 0;
    
    foreach (@{$self->{classes}}) {
        my $total = $self->{sets}->{$_}->{total};
        $priors->{$_} = $total;
        $sum += $total;
    }
    
    foreach (@{$self->{classes}}) {
        $priors->{$_} = $priors->{$_} / $sum;
    }
    
    $sum = 0;
    foreach (@{$self->{classes}}) {
        my $data = $self->{sets}->{$_};
        my $score = $priors->{$_};
        foreach (@{$words}) {
            my $freq = $data->{freqs}->{$_};
            $score = $score * (($freq) ? 
                ($freq / $data->{total}) : 0.00000000001);
        }
        $scores->{$_} = $score;
        $sum += $score;
    }

    foreach (@{$self->{classes}}) {
        $scores->{$_} = $scores->{$_} / $sum;
    }

    return $scores;
}

sub freeze {
    my ($self, $file) = @_;
    my $mp = Data::MessagePack->new();
    my $data = $mp->pack([$self->{classes}, $self->{sets}]); 
    open(my $out, '>:raw', $file) or die "Unable to open: $!";
    print $out $data;
    close($out);
}

sub unfreeze {
    my ($self, $file) = @_;
    my $size = -s $file;
    my $bin;
    open(my $in, '<:raw', $file) or die "Unable to open: $!";
    read($in, $bin, $size);
    close($in);
    my $mp = Data::MessagePack->new();
    my $data = $mp->unpack($bin);
    $self->{classes} = @{$data}[0];
    $self->{sets} = @{$data}[1];
}

1;