#!/usr/bin/perl
use warnings;
use strict;
use POE qw(Component::Server::TCP);

# Start a TCP server. Client input will be logged to the console and
# echoed back to the client, one line at a time.

POE::Component::Server::TCP->new
( Port => 8000,
  ClientInput => \&handle_input,
);

# port to listen on
# method to call with input
# Start the server.
$poe_kernel->run( );
exit 0;

sub handle_input {
    my ( $session, $heap, $input ) = @_[ SESSION, HEAP, ARG0 ];
# $session is a POE::Session object unique to this connection,
# $heap is this connection's between-callback storage.
# New data from client is in $input. Newlines are removed.
# To echo input back to the client, simply say:
    $heap->{client}->put($input);
# and log it to the console
    print "client ", $session->ID, ": $input\n";
}
