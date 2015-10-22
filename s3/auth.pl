use DateTime;
use Digest::HMAC_SHA1;
use MIME::Base64;
use Modern::Perl;

use Env qw(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY);

# http://docs.aws.amazon.com/AmazonS3/latest/API/APIRest.html

my $BUCKET = "irrs3";
my $HOST = "$BUCKET.s3.amazonaws.com";
my $KEY = "test";

my $dt = DateTime->now();
my $now = $dt->strftime('%a, %d %b %Y %H:%M:%S GMT');

my $hmac = Digest::HMAC_SHA1->new($AWS_SECRET_ACCESS_KEY);
$hmac->add("GET\n\n\n$now\n/$BUCKET/$KEY");
my $digest = MIME::Base64::encode_base64($hmac->digest, '');

my $curl = sprintf("\ncurl -v -H \"Date: %s\" -H \"Authorization: AWS %s:%s\" http://%s/$KEY\n",
                   ($now, $AWS_ACCESS_KEY_ID, $digest, $HOST));

say($curl);

system($curl);

