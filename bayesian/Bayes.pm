package Bayes;

use 5.014;

use warnings;
use strict;

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
        foreach my $w (@{$words}) {
            my $freq = $data->{freqs}->{$w};
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

1;