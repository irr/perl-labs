use DBI;
use Modern::Perl;

# CREATE KEYSPACE IF NOT EXISTS irr WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };
# CREATE TABLE series (id text, ts timestamp, val text, PRIMARY KEY (id,ts),) WITH CLUSTERING ORDER BY (ts DESC);

my $dbh= DBI->connect("dbi:Cassandra:keyspace=irr", undef, undef, {RaiseError => 1});

my $ts = time();

foreach my $i (0..9) {
    say("inserting timestamp $i [$ts]...");
    $dbh->do("INSERT INTO series (id, ts, val) VALUES (?, ?, ?) USING TTL 20;",
             undef, "irr-id", $ts, "".$i);
    $ts = $ts - 1000;
}
 
my $rows = $dbh->selectall_arrayref("SELECT * FROM series LIMIT 10;");
 
for my $row (@$rows) {
    say("retrieving timestamp ${$row}[1] = ${$row}[2]...");
}

$dbh->disconnect;

