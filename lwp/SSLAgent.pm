package SSLAgent;

use base 'LWP::UserAgent';

sub new {
    my ($class, %cnf) = @_;
    $cnf{ssl_opts} = { verify_hostname => 0 };
    my $self = $class->SUPER::new(%cnf);
    bless $self, $class;
    return $self;
}

sub get_basic_credentials {
    return 'admin', 'admin123';
}

1;
