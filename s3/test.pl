use strict;
use warnings;
use diagnostics;

use 5.014;

use Amazon::S3;

my $access_key = $ENV{'AWS_ACCESS_KEY_ID'};
my $secret_key = $ENV{'AWS_SECRET_ACCESS_KEY'};

print "Connecting...\n";

my $conn = Amazon::S3->new({
        aws_access_key_id     => $access_key,
        aws_secret_access_key => $secret_key,
        host                  => 'api.uolos.com.br',
        secure                => 0,
        retry                 => 0,
});

print "Retrieving buckets...\n";
my @buckets = @{$conn->buckets->{buckets} || []};

print "Listing buckets...\n";
foreach my $bucket (@buckets) {
    print $bucket->bucket . "\t" . $bucket->creation_date . "\n";
}

