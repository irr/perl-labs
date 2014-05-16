package Bayes;

use 5.014;

use warnings;
use strict;

use JSON;

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;
    die "missing required classes" unless $args{classes};
    $self->{classes} = $args{classes};
    foreach (@{$self->{classes}}) {
        $self->{sets}->{$_} = { freqs => {}, total => 0 };
    }
    return $self;
}

sub fromfile {
    my ($class, %args) = @_;
    my $self = bless {}, $class;
    die "missing required file" unless $args{file};
    $self->unfreeze($args{file});
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
    my $json = JSON->new->allow_nonref();
    my $data = $json->encode([$self->{classes}, $self->{sets}]); 
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
    my $json = JSON->new->allow_nonref();
    my $data = $json->decode($bin);
    $self->{classes} = @{$data}[0];
    $self->{sets} = @{$data}[1];
}

1;