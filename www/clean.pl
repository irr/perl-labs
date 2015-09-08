use Modern::Perl;
use Data::Dumper;
use Encode qw(decode encode);
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
my $url = "http://www.uol.com.br/";

$mech->get($url);

if ($mech->is_html() && $mech->success()) {
    say encode('utf8', $mech->text());
} else {
    say Dumper($mech->response());
}
