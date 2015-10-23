package auth;

use strict;
use nginx;

use Data::Dumper;
use DateTime;
use Digest::HMAC_SHA1;
use MIME::Base64;

use Env qw(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY);

sub handler {
    my $r = shift;

    if ($r->request_method ne "GET") {
        return DECLINED;
    }

    &patch($r);
}

sub patch {
    my $r = shift;

    my $bucket = $r->variable("bucket");
    my $key = (split('/', $r->uri))[1];
    my $dt = DateTime->now();
    my $now = $dt->strftime('%a, %d %b %Y %H:%M:%S GMT');

    my $hmac = Digest::HMAC_SHA1->new($AWS_SECRET_ACCESS_KEY);
    $hmac->add("GET\n\n\n$now\n/$bucket/$key");
    my $digest = MIME::Base64::encode_base64($hmac->digest, '');

    my $uri = sprintf("/proxy/%s:%s/%s%s", $AWS_ACCESS_KEY_ID, $digest, $now, $r->uri);
    $r->internal_redirect($uri);

    return OK;
}

1;

