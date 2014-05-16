#!/usr/bin/env perl

use DBI;
use Time::HiRes qw(time);
$start = time;
my $dbh = DBI->connect("dbi:mysql:host=127.0.0.1;dbi:mysql:database=mysql;port=3306",
                     "root","mysql");
my $user = 'root';
my $sth = $dbh->prepare("SELECT Host FROM user WHERE User=?");
$sth->execute($user);
while (my $ref = $sth->fetchrow_hashref()) {
  print "found a row: $ref->{'Host'}\n";
}
my $rows = $sth->rows;
print("total rows: $rows\n");
$sth->finish();
undef $sth;
$dbh->disconnect();
undef $dbh;
printf "%.6f\n", time() - $start;