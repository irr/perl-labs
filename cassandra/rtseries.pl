use DBI;
use Time::HiRes qw( time );
use Data::Dumper;

# CREATE KEYSPACE IF NOT EXISTS irr WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };
# CREATE TABLE series (id text, ts text, val text, PRIMARY KEY (id,ts),) WITH CLUSTERING ORDER BY (ts DESC);

my $dbh= DBI->connect("dbi:Cassandra:keyspace=irr", undef, undef, {RaiseError => 1});

my $ts = time();

foreach my $i (0..9) {
  $dbh->do("INSERT INTO series (id, ts, val) VALUES (?, ?, ?) USING TTL 20;",
            undef, "irr-id", $ts--, "".$i);
}
 
my $rows = $dbh->selectall_arrayref("SELECT * FROM series LIMIT 10;");
 
for my $row (@$rows) {
    print(Dumper($row));
}

$dbh->disconnect;

