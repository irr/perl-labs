use strict;
use warnings;
use diagnostics;

use 5.014;

use Crypt::CBC;
use Crypt::Rijndael;
#use Crypt::Twofish;

sub md5 {
    my $ctx = Digest::MD5->new;
    $ctx->add($_[0]);
    $ctx->hexdigest;
}

my $key = 'c6bef73b51e2f696'; 
my $iv = 'aa90025f918a9696';

my $text = "alessandra cristina dos santos";

#my $cbc = Crypt::CBC->new(cipher=>'Twofish', key=>$key, iv=>$iv);
my $cbc = Crypt::CBC->new(cipher=>'Rijndael', key=>$key, iv=>$iv);

my $ciphertext = $cbc->encrypt($text);
my $hexcipher = unpack("H*", $ciphertext);
my $decrypted = $cbc->decrypt(pack("H*", $hexcipher));

print "TEXT     : $text\n";
printf "    (MD5): %s\n", &md5($text);
print "ENCRYPTED: $hexcipher\n";
printf "    (MD5): %s\n", &md5($hexcipher);
print "DECRYPTED: $decrypted\n";
printf "    (MD5): %s\n", &md5($decrypted);

