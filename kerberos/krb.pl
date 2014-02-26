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

usage() unless (($add or $del) and ($user and $pass));

my $handle = Authen::Krb5::Admin->init_with_skey("root/admin", "/root/kerberos/root.keytab");

if ($handle) {
    if ($add and $pass) {
        my $ap = Authen::Krb5::Admin::Principal->new;
        $ap->principal(Authen::Krb5::parse_name($user));
        if ($handle->create_principal($ap, $pass)) {
            say "$user created.";
            exit 0;
        } else {
            exit Authen::Krb5::Admin::error_code;
        }
    } elsif ($del) {
        my $p = Authen::Krb5::parse_name($user);
        if ($handle->delete_principal($p)) {
            say "$user removed.";
            exit 0;
        } else {
            exit Authen::Krb5::Admin::error_code;
        }
    }
} else {
    exit Authen::Krb5::Admin::error_code;
}

exit 1;