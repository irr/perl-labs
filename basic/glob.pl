use feature qw(say);

{
    package Test;
    use feature qw(say);

    our @fields = qw(id name money);

    sub new {
        my ($class, %args) = @_;
        bless { %args }, $class;
    }

    for my $f (@fields) {
        no strict 'refs';
        *$f = sub { 
                if ((scalar @_) > 1) {
                    my ($self, $val) = @_;
                    $self->{$f} = $val;
                } else {
                    shift->{$f};
                }   
        };

        sub string {
            my $self = shift;
            say "\ndumping object $self";
            say "id=".$self->id;
            say "name=".$self->name;
            say "money=".$self->money;
        }
    }
}

sub dump {
    my $obj = shift;
    $obj->string();
}

my $t = new Test(id => "irr", name => "Ivan", money => 60000);
&dump($t);

$t->id("irr2");
&dump($t);



