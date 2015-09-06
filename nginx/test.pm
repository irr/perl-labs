package test;

use strict;
use nginx;

use JSON;
use Redis;

sub handler {
  my $r = shift;

  if ($r->header_only) {
    $r->send_http_header("application/json");
    return OK;
  }

  &next($r);
}

sub next {
  my $r = shift;

  if ($r->has_request_body(\&post)) {
    return OK;
  }
}

sub finish {
  my $r = shift;

  $r->send_http_header("application/json");
  $r->print($r->variable("json"));
  $r->flush();

  return OK;
}

sub post {
  my $r = shift;

  my $json = JSON->new->allow_nonref;
  my %params = ();

  foreach (split("&", $r->request_body)) {
    my($k, $v) = split "=", $_;
    $params{$r->unescape($k)} = $r->unescape($v);
  }

  my $json_text;
  my $delay = 0;

  eval {
    if ($params{'delay'}) {
        $delay = 0 + $params{'delay'};
    }
    my $redis = Redis->new();
    my $key = $r->uri;
    $redis->set('last_uri' => $key);
    $redis->incr('hits');
    $json_text = $json->encode( { $key => \%params } );
    $redis->quit;
  };

  if ($@) {
  	$json_text = $json->encode( { "error" => $@ });
  	$r->status(500);
  }

  $r->variable("json", $json_text);

  $r->sleep($delay, \&finish);
}

1;

