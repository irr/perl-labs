package krbadm2;

use strict;
use nginx;

use JSON;
use Authen::Krb5;
use Authen::Krb5::Admin qw(:constants);
use Try::Tiny;

Authen::Krb5::init_context;

sub krbauth {
    return Authen::Krb5::Admin->init_with_skey("root/admin", "/etc/root.keytab");
}

sub handler {
    my $r = shift;

    if ($r->header_only) {
        $r->send_http_header("application/json");
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
            my $ap = $kadm5->get_principal(Authen::Krb5::parse_name($params{user}));            
            if ($ap) {
                my $ap = Authen::Krb5::parse_name($params{user});
                if ($kadm5->chpass_principal($ap, $params{pass})) {
                    $r->log_error(0, "user [$params{user}] updated");
                    return OK;
                } else {
                    my $code = Authen::Krb5::Admin::error_code;
                    $r->log_error(0, "error [$code] updating user [$params{user}]");
                    return 403;
                }
            } else {
                $ap = Authen::Krb5::Admin::Principal->new;
                $ap->principal(Authen::Krb5::parse_name($params{user}));
                if ($kadm5->create_principal($ap, $params{pass})) {
                    $r->log_error(0, "user [$params{user}] added");
                    return OK;
                } else {
                    my $code = Authen::Krb5::Admin::error_code;
                    $r->log_error(0, "error [$code] adding user [$params{user}]");
                    return 403;
                }
            }
        } elsif ($params{action} eq 'del') {
            my $princ = Authen::Krb5::parse_name($params{user});
            my $ap = $kadm5->get_principal($princ);            
            if ($ap) {            
                if ($kadm5->delete_principal($princ)) {
                    $r->log_error(0, "user [$params{user}] deleted");
                    return OK;
                } else {
                    my $code = Authen::Krb5::Admin::error_code;
                    $r->log_error(0, "error [$code] removing user [$params{user}]");
                    return 403;
                }   
            } else {
                return 404;
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

