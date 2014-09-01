use strict;
use warnings;

{ 
    package Animal;
    sub sound { "animal!" }
    sub speak {
        my $self = shift;
        print $self->name, ' goes ', $self->sound, "\n";
    }
    sub name {
        my $self = shift;
        ref $self ? $self->{Name} : "an unnamed $self";
    }
    sub new {
        my $class = shift;
        my $name = shift;
        my $self = { Name => $name };
        bless $self, $class;
    }
    sub DESTROY {
        my $self = shift;
        print 'object [', $self->name, "] has been released.\n";
    }
}

{
    package Dog;
    use base qw(Animal);
    sub sound { "bark" }
    sub speak {
        my $self = shift;
        $self->SUPER::speak(@_);
        print $self->name." [overriding methods...][@_]\n";
    }
    sub DESTROY {
        my $self = shift;
        print 'object [', $self->name, "] destructor called.\n";
        $self->SUPER::DESTROY;
    }
}

my $lara = Dog->new("Lara");
$lara->speak("argument 1");
Dog::speak($lara, "argument 1"); # same as $lara->speak();

# unnamed (like class methods)
Dog->speak("arguments...");

{ 
    package Barn;
    sub new { bless [ ], shift }
    sub add { push @{+shift}, shift }
    sub contents { @{+shift} }
    sub DESTROY {
        my $self = shift;
        print "$self is being destroyed...\n";
        while (@$self) {
            my $homeless = shift @$self;
            print $homeless.' ', $homeless->name, " goes homeless.\n";
        }
    }
}

my $barn = Barn->new;
$barn->add(Dog->new('Babi'));
$barn->add(Dog->new('Luma'));
print "Burn the barn:\n";
for ($barn->contents) {
    print $_,":",$_->name."\n";
}
$barn = undef;
print "End of program.\n";


