package SSLAgent;

use base 'LWP::UserAgent';

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new(ssl_opts => { verify_hostname => 0 });
    bless $self, $class;
    return $self;
}

sub get_basic_credentials {
    return 'admin', 'admin123';
}

1;
