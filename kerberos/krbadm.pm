package krbadm;

use strict;
use nginx;
use Try::Tiny;

use JSON;
use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);

Authen::Krb5::init_context;

sub krbauth {
    return Authen::Krb5::Admin->init_with_skey("root/admin", "/etc/root.keytab");
}

sub handler {
    my $r = shift;

    if ($r->request_method eq "HEAD") {
        $r->send_http_header;
        return OK;
    }

    if ($r->has_request_body(\&post)) {
        return OK;
    }

    try {
        my $kadm5 = krbauth();

        my @names = $kadm5->get_principals();
        if ($#names > 0) {    
            my $json = JSON->new->allow_nonref;
            my $princs = $json->encode({ "principals" => \@names });
            $r->send_http_header("application/json");        
            $r->print($princs);
            $r->rflush;
            return OK;    
        } else {
            $r->log_error(0, "no principals found!");
            return 404;
        }
    } catch {
        $r->log_error(0, "error listing principals [$_]");
        return 500;
    }
}

sub post {
    my $r = shift;

    my %params = ();

    foreach (split("&", $r->request_body)) {
        my($k, $v) = split "=", $_;
        $params{$r->unescape($k)} = $r->unescape($v);
    }

    $r->send_http_header;

    return 400 unless ((length($params{action}) > 0) and (length($params{user}) > 0));

    try {
        my $kadm5 = krbauth();

        if ($params{action} eq 'add') {
            return 400 unless (length($params{pass}) > 0);
            my $ap = Authen::Krb5::Admin::Principal->new;
            $ap->principal(Authen::Krb5::parse_name($params{user}));
            if ($kadm5->create_principal($ap, $params{pass})) {
                return OK;
            } else {
                my $code = Authen::Krb5::Admin::error_code;
                $r->log_error(0, "error [$code] adding user [$params{user}]");
                return 403;
            }
        } elsif ($params{action} eq 'del') {
            my $princ = Authen::Krb5::parse_name($params{user});
            if ($kadm5->delete_principal($princ)) {
                return OK;
            } else {
                my $code = Authen::Krb5::Admin::error_code;
                $r->log_error(0, "error [$code] removing user [$params{user}]");
                return 403;
            }        
        } elsif (($params{action} eq 'on') or ($params{action} eq 'off')) {
            my $princ = Authen::Krb5::parse_name($params{user});
            $princ->attributes(($params{action} eq 'on') ? 0 : KRB5_KDB_DISALLOW_RENEWABLE);
            if ($kadm5->modify_principal($princ)) {
                return OK;
            } else {
                my $code = Authen::Krb5::Admin::error_code;
                $r->log_error(0, "error [$code] enabling/disabling user [$params{user} $params{action}]");
                return 403;
            }            
        } else {
            return 400;
        }
    } catch {
        $r->log_error(0, "error adding/removing user [$_]");
        return 500;
    }
}
 
1;

