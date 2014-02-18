#!/usr/bin/env perl
use 5.014;

use strict;
use warnings;
use diagnostics;

use Getopt::Long;

use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);

Authen::Krb5::init_context;

sub usage {
    print "krb [--add|--del] --user=<username> --pass=<password>\n";
    exit 1;
}

my ($add, $del, $user, $pass) = ('') x 4;

GetOptions( "add!" => \$add,
            "del!" => \$del,
            "user=s" => \$user,
            "pass:s" => \$pass );

my $success;
my $handle = Authen::Krb5::Admin->init_with_password("root/admin", "sun123") or die Authen::Krb5::Admin::error;

usage() if ($add and $del);

if ($add and $pass) {
    my $ap = Authen::Krb5::Admin::Principal->new;
    $ap->principal(Authen::Krb5::parse_name($user));
    $success = $handle->create_principal($ap, $pass);
    if ($success) {
        say "$user created > " . $success;
        exit 0;
    } else {
        exit Authen::Krb5::Admin::error;  
    }
} elsif ($del) {
    my $p = Authen::Krb5::parse_name($user);
    $success = $handle->delete_principal($p);
    if ($success) {
        say "$user removed > " . $success;
        exit 0;
    } else {
        exit Authen::Krb5::Admin::error;  
    }
}

exit 1;