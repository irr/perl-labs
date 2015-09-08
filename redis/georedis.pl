use Modern::Perl;
use Data::Dumper;
use RedisDB;

my $redis = RedisDB->new(host => 'localhost', port => 6379, raise_error => 0);

$redis->send_command("geoadd", "Sicily", "13.361389", "38.115556", "Palermo", RedisDB::IGNORE_REPLY);
$redis->send_command("geoadd", "Sicily", "15.087269", "37.502669", "Catania", RedisDB::IGNORE_REPLY);

sub geo_hash {
    my ($cmd, $key, $city) = @_;

    say "command: @_";

    $redis->send_command($cmd, $key, $city, sub {
            # my $reply = $_[1];
            if (ref(@_) =~ /^RedisDB::Error/) {
                say "error: \n".Dumper(@_);
            } else {
                say "get_reply: \n".Dumper(@_);
            }
        });
    $redis->mainloop();
}

geo_hash("geohash", "Sicily", "Palermo");
