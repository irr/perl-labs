use DBI;
use Modern::Perl;

# CREATE KEYSPACE IF NOT EXISTS irr WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };
# CREATE TABLE series (id text, ts timeuuid, val int, PRIMARY KEY (id,ts),) WITH CLUSTERING ORDER BY (ts DESC);

my $dbh= DBI->connect("dbi:Cassandra:keyspace=irr", undef, undef, {RaiseError => 1});

foreach my $i (0..9) {
    say("inserting timestamp $i...");
    $dbh->do("INSERT INTO series (id, ts, val) VALUES (?, now(), ?) USING TTL 20;",
             undef, "irr-id", $i);
}
 
my $rows = $dbh->selectall_arrayref("SELECT id, unixTimestampOf(ts) as ts, val FROM series LIMIT 10;");
 
for my $row (@$rows) {
    say("retrieving timestamp ${$row}[1] = ${$row}[2]...");
}

$dbh->disconnect;

