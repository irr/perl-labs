#!/usr/bin/env perl

# sudo yum install krb5-server krb5-workstation
# sudo apt-get install krb5-kdc krb5-admin-server krb5-user krb5-multidev libkrb5-dev

# Ubuntu and CentOS
# sudo vim /etc/krb5.conf (rdns = false)

# Ubuntu
# https://help.ubuntu.com/14.04/serverguide/kerberos.html
# sudo vim /etc/krb5kdc/kadm5.acl
# sudo service krb5-admin-server restart
# sudo service krb5-kdc restart

# CentOS
# sudo vim /var/kerberos/krb5kdc/kdc.conf
# sudo vim /var/kerberos/krb5kdc/kadm5.acl

# sudo kdb5_util create -s
# sudo kadmin.local -q "addprinc root/admin"
# sudo kadmin.local 
# > addprinc -randkey host/irrlab.com.br
# > addprinc -randkey host/admin
# > ktadd -k /etc/krb5.keytab host/irrlab.com.br
# > ktadd -k /etc/hostadm.keytab host/admin
# sudo chown irocha: /etc/*.keytab
# sudo restorecon -rv /etc
# sudo lokkit --port=88:tcp
# sudo lokkit --port=88:udp
# sudo chkconfig krb5kdc on
# sudo chkconfig kadmin on
# sudo service krb5kdc start
# sudo service kadmin start

# ./krb.pl --add  --suser=host/admin --spass=/etc/hostadm.keytab --user=ivan --pass=sun123
# ./krb.pl --upd  --suser=host/admin --spass=/etc/hostadm.keytab --user=ivan --pass=sun123sun123
# ./krb.pl --del  --suser=host/admin --spass=/etc/hostadm.keytab --user=ivan
# ./krb.pl --lst  --suser=host/admin --spass=/etc/hostadm.keytab

# sudo kadmin.local -q "listprincs"

# sudo yum install perl-ExtUtils-Embed perl-Getopt-ArgvFile
# pp -B -o centos6.5/krb krb.pl

# cpanm -v -n Authen::Krb5::Admin

# kinit host/admin@IRRLAB.COM.BR -k -t /etc/hostadm.keytab
# modprinc -policy disable_policy host/admin
# modprinc -clearpolicy  host/admin
# modprinc +allow_renewable host/admin
# modprinc -allow_renewable host/admin
# ./krb.pl --lst --suser=host/admin --spass=/etc/hostadm.keytab

use 5.010;

use strict;
use warnings;
use diagnostics;

use Getopt::Long;

use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);

use JSON;

my $json = JSON->new->allow_nonref;

Authen::Krb5::init_context;

sub usage {
    print "krb-user-admin, version 0.1e (ivan.ribeiro\@gmail.com)\n";
    print "krb [--add|--del|--lst|--enable|--disable] --suser=host/admin --spass=/etc/hostadm.keytab --user=<username> --pass=<password>\n";
    exit 1;
}

sub status {
    my $user = shift;
    my $status = shift;
    my $ret = $json->encode({ "user" => $user, "status" => $status });
    print "$ret\n";
}

my ($add, $del, $lst, $enable, $disable, $user, $pass, $suser, $spass) = ('') x 9;

GetOptions( "add!" => \$add,
            "del!" => \$del,
            "lst!" => \$lst,
            "enable!" => \$enable,
            "disable!" => \$disable,
            "user=s" => \$user,
            "pass:s" => \$pass,
            "suser:s" => \$suser, 
            "spass:s" => \$spass );

usage() unless (($suser and $spass) and ($lst or ($del and $user) or 
        ($enable and $user) or ($disable and $user) or 
        ($add and $user and $pass)));

my $handle = Authen::Krb5::Admin->init_with_skey($suser, $spass);

if ($handle) {
    if ($lst) { 
        my @names = $handle->get_principals();
        if ($#names > 0) {    
            my $princs = $json->encode({ "principals" => \@names });
            print "$princs\n";
        } else {
            print "{\"principals\":[]}\n";
        }  
        exit 0;      
    } elsif (($enable and $user) or ($disable and $user)) {
        my $ap = $handle->get_principal(Authen::Krb5::parse_name($user));
        if ($ap) {
            $ap->attributes(($enable) ? 0 : KRB5_KDB_DISALLOW_RENEWABLE);
            if ($handle->modify_principal($ap)) {
                status($user, 0);
                exit 0;
            } else {
                status($user, Authen::Krb5::Admin::error_code);
                exit Authen::Krb5::Admin::error_code;   
            }
        } else {
            status($user, 1);
            exit 1;
        }
    } elsif ($add and $pass) {
        my $ap = $handle->get_principal(Authen::Krb5::parse_name($user));
        if ($ap) {
            $ap = Authen::Krb5::parse_name($user);
            if ($handle->chpass_principal($ap, $pass)) {
                status($user, 0);
                exit 0;
            } else {
                status($user, Authen::Krb5::Admin::error_code);
                exit Authen::Krb5::Admin::error_code;   
            }
        }        
        $ap = Authen::Krb5::Admin::Principal->new;
        $ap->principal(Authen::Krb5::parse_name($user));
        if ($handle->create_principal($ap, $pass)) {
            status($user, 0);
            exit 0;
        } else {
            status($user, Authen::Krb5::Admin::error_code);
            exit Authen::Krb5::Admin::error_code;
        }
    } elsif ($del) {
        my $p = Authen::Krb5::parse_name($user);
        my $ap = $handle->get_principal($p); 
        if ($ap) {
            if ($handle->delete_principal($p)) {
                status($user, 0);
                exit 0;
            } else {
                status($user, Authen::Krb5::Admin::error_code);
                exit Authen::Krb5::Admin::error_code;
            }
        } else {
            status($user, 0);
            exit 0;
        }
    }
} else {
   status("", Authen::Krb5::Admin::error_code);
    exit Authen::Krb5::Admin::error_code;
}

exit 1;
