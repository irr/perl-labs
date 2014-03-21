#!/usr/bin/env perl
# perl krb.pl --add --user=irr --pass=test123
# perl krb.pl --del --user=irr
# sudo kadmin.local -q "listprincs"
use 5.010;

use strict;
use warnings;
use diagnostics;

use Getopt::Long;

use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);

Authen::Krb5::init_context;

sub usage {
    print "krb [--add|--del|--upd] --user=<username> --pass=<password>\n";
    exit 1;
}

my ($add, $del, $upd, $user, $pass) = ('') x 5;

GetOptions( "add!" => \$add,
            "del!" => \$del,
            "upd!" => \$upd,
            "user=s" => \$user,
            "pass:s" => \$pass );

usage() unless (($del and $user) or (($add or $upd) and $user and $pass));

my $handle = Authen::Krb5::Admin->init_with_skey("root/admin", "/etc/root.keytab");

if ($handle) {
    if ($add and $pass) {
        my $ap = Authen::Krb5::Admin::Principal->new;
        $ap->principal(Authen::Krb5::parse_name($user));
        if ($handle->create_principal($ap, $pass)) {
            print "$user created.\n";
            exit 0;
        } else {
            exit Authen::Krb5::Admin::error_code;
        }
    } elsif ($upd and $pass) {
        my $ap = Authen::Krb5::parse_name($user);
        if ($ap) {
             if ($handle->chpass_principal($ap, $pass)) {
                print "$user updated.\n";
                exit 0;
             }
        } else {
            exit Authen::Krb5::Admin::error_code;   
        }
    } elsif ($del) {
        my $p = Authen::Krb5::parse_name($user);
        if ($handle->delete_principal($p)) {
            print "$user removed.\n";
            exit 0;
        } else {
            exit Authen::Krb5::Admin::error_code;
        }
    }
} else {
    exit Authen::Krb5::Admin::error_code;
}

exit 1;