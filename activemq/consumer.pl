use Net::STOMP::Client;
 
$stomp = Net::STOMP::Client->new(host => "127.0.0.1", port => 61613);
$stomp->connect(login => "guest", passcode => "guest");
# declare a callback to be called for each received message frame
$stomp->message_callback(sub {
    my($self, $frame) = @_;
    $self->ack(frame => $frame);
    printf("received: %s\n", $frame->body());
    return($self);
});
# subscribe to the given queue
$stomp->subscribe(
    destination => "/queue/test",
    id          => "testsub",          # required in STOMP 1.1
    ack         => "client",           # client side acknowledgment
);
# wait for a specified message frame
$stomp->wait_for_frames(callback => sub {
    my($self, $frame) = @_;
    if ($frame->command() eq "MESSAGE") {
        # stop waiting for new frames if body is "quit"
        return(1) if $frame->body() eq "quit";
    }
    # continue to wait for more frames
    return(0);
});
$stomp->unsubscribe(id => "testsub");
$stomp->disconnect();