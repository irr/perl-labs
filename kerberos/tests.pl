use 5.014;

use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);
use YAML;

Authen::Krb5::init_context;

my $handle = Authen::Krb5::Admin->init_with_password("root/admin", "sun123") or die Authen::Krb5::Admin::error;
my $principal = ($handle->get_principals('demo@CLOUDUOL.COM.BR'))[0];

if  ($principal) {
    say Dump($principal);
}

my $ap = Authen::Krb5::Admin::Principal->new;
$ap->principal(Authen::Krb5::parse_name("demo1"));

my $success = $handle->create_principal($ap, "sun123") or die Authen::Krb5::Admin::error;
say "demo1 created > " . Dump($success);

my $p = Authen::Krb5::parse_name("demo1");

$success = $handle->delete_principal($p) or warn Authen::Krb5::Admin::error;
say "demo1 removed > " . Dump($success);
