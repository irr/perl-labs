use Net::STOMP::Client;
 
$stomp = Net::STOMP::Client->new(host => "127.0.0.1", port => 61613);
$stomp->connect(login => "guest", passcode => "guest");
$stomp->send(destination => "/queue/test", body => "hello world!");
$stomp->disconnect();
