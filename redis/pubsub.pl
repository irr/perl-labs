#!/usr/local/bin/perlbrew.sh

use Redis;

my $pub = Redis->new();
my $sub = Redis->new();

my $sub_cb = sub { my ($message, $topic) = @_; print("$message:$topic\n") };
$sub->subscribe('aa', 'bb', $sub_cb);

$pub->publish('aa', 'v1');

$sub->wait_for_messages(1) while 1;
