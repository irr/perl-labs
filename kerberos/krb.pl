#!/usr/bin/env perl
# perl krb.pl --add --user=irr --pass=test123
# perl krb.pl --del --user=irr
# sudo kadmin.local -q "listprincs"

# sudo yum install perl-ExtUtils-Embed perl-Getopt-ArgvFile
# pp -B -o centos6.5/krb krb.pl

use 5.010;

use strict;
use warnings;
use diagnostics;

use Getopt::Long;

use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);

Authen::Krb5::init_context;

sub usage {
    print "krb-user-admin, version 0.1b (ivan.ribeiro\@gmail.com)\n";
    print "krb [--add|--del|--upd] --suser=root/admin --spass=/etc/root.keytab --user=<username> --pass=<password>\n";
    exit 1;
}

my ($add, $del, $upd, $user, $pass, $suser, $spass) = ('') x 7;

GetOptions( "add!" => \$add,
            "del!" => \$del,
            "upd!" => \$upd,
            "user=s" => \$user,
            "pass:s" => \$pass,
            "suser:s" => \$suser, 
            "spass:s" => \$spass );

usage() unless ($suser and $spass) and (($del and $user) or (($add or $upd) and $user and $pass));

my $handle = Authen::Krb5::Admin->init_with_skey($suser, $spass);

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