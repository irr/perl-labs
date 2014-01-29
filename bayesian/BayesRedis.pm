package BayesRedis;

use 5.014;

use warnings;
use strict;

use Redis;
use Try::Tiny;

sub k {
    my ($ns, $cls, $s) = @_;
    return "$ns:$cls:_$s";
}

sub fr {
    my ($k, $w) = @_;
    return "$k:$w";
}

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;
    die "missing required namespace" unless $args{namespace};
    die "missing required classes" unless $args{classes};
    die "missing required host" unless $args{host};
    die "missing required port" unless $args{port};
    $self->{classes} = $args{classes};
    $self->{namespace} = $args{namespace};
    $self->{redis} = Redis->new(server => "$args{host}:$args{port}",
                                reconnect => $args{reconnect});
    try {
        foreach (@{$self->{classes}}) {
            $self->{redis}->sadd($self->{namespace} => $_);
            $self->{redis}->set(k($self->{namespace}, $_, "total") => "0");
        }
    } catch {
        die "error initializing redis classes [$self->{classes}] ($_)";
    }
    return $self;
}

sub learn {
    my ($self, $class, $words) = @_;
    my $key = k($self->{namespace}, $class, "freqs");
    my $tot = k($self->{namespace}, $class, "total");
    try {
        $self->{redis}->multi;
        foreach (@{$words}) {
            my $w = fr($key, $_);
            $self->{redis}->setnx($w, "0");
            $self->{redis}->incr($w);
            $self->{redis}->incr($tot);
        } 
        $self->{redis}->exec;
    } catch {
        die "error learning redis class [$class] ($_)";
    }
}

sub query {
    my ($self, $words) = @_;
    my ($scores, $priors) = ({}, {});
    my $sum = 0;
    
    try {
        foreach (@{$self->{classes}}) {
            my $total = $self->{redis}->get(k($self->{namespace}, $_, "total"));
            $priors->{$_} = $total;
            $sum += $total;
        }
        
        foreach (@{$self->{classes}}) {
            $priors->{$_} = $priors->{$_} / $sum;
        }
        
        $sum = 0;
        foreach (@{$self->{classes}}) {
            my $class = $_;
            my $total = $self->{redis}->get(k($self->{namespace}, $class, "total"));
            my $score = $priors->{$class};
            foreach (@{$words}) {
                my $freq = $self->{redis}->get(fr(k($self->{namespace}, $class, "freqs"), $_));
                $score = $score * ((defined($freq)) ? ($freq / $total) : 0.00000000001);
            }
            $scores->{$class} = $score;
            $sum += $score;
        }

        foreach (@{$self->{classes}}) {
            $scores->{$_} = $scores->{$_} / $sum;
        }

        return $scores;
    } catch {
        warn "error querying ($_)";
        return undef;
    }
}

1;