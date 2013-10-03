#!/usr/bin/perl

use warnings;
use strict;

use POE qw(Component::Server::TCP Filter::HTTPD);
use HTTP::Response;
use JSON;

# Spawn a web server on port 8088 of all interfaces.

POE::Component::Server::TCP->new(
    Alias        => "web_server",
    Port         => 8088,
    ClientFilter => 'POE::Filter::HTTPD',

    # The ClientInput function is called to deal with client input.
    # Because this server uses POE::Filter::HTTPD to parse input,
    # ClientInput will receive HTTP requests.

    ClientInput => sub {
        my ($kernel, $heap, $request) = @_[KERNEL, HEAP, ARG0];

        # Filter::HTTPD sometimes generates HTTP::Response objects.
        # They indicate (and contain the response for) errors that occur
        # while parsing the client's HTTP request.  It's easiest to send
        # the responses as they are and finish up.

        if ($request->isa("HTTP::Response")) {
            $heap->{client}->put($request);
            $kernel->yield("shutdown");
            return;
        }

        my $response = HTTP::Response->new(200);
        my $json = JSON->new->allow_nonref;
        my $value = { name => "ivan", poe => "rocks!" };
        my $content = $json->pretty->encode($value);
        $response->push_header('Content-type', 'application/json');
        $response->content($content);

        # Once the content has been built, send it back to the client
        # and schedule a shutdown.

        $heap->{client}->put($response);
        $kernel->yield("shutdown");
    }
    );

# Start POE.  This will run the server until it exits.

$poe_kernel->run();
exit 0;
