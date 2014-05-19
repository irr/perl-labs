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

  if ($r->has_request_body(\&post)) {
    return OK;
  }

  return 400;
}

sub post {
  my $r = shift;

  my $json = JSON->new->allow_nonref;
  my %params = ();

  foreach (split("&", $r->request_body)) {
    my($k, $v) = split "=", $_;
    $params{$r->unescape($k)} = $r->unescape($v);
  }
  $params{"perl"} = $];
  
  my $json_text;

  eval {
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

  $r->send_http_header("application/json");
  $r->print($json_text);
  $r->flush();
    
  return OK;
}
 
1;

