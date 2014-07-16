# pp -M Text::CSV_XS -M Finance::Quote::Yahoo::Brasil -M Finance::QuoteHist::Yahoo -M Finance::QuoteHist::Google -M PDL::NiceSlice::FilterUtilCall -o fetch fetch.pl

use DateTime;

use Finance::Quote;
use Finance::QuoteHist;

use PDL;
use PDL::NiceSlice;
use PDL::Finance::TA ':Func';

my $p = ($#ARGV < 0) ? "PETR4" : $ARGV[0];

my $q = Finance::Quote->new("Yahoo::Brasil");
$q->timeout(60);
$q->set_currency("BRL");
 
my %info = $q->fetch("yahoo_brasil", $p);

foreach (qw(close open last date time exchange bid volume high low pe p_change name success)) {
    print "$_: $info{$p, $_}, ";
}

$q = Finance::QuoteHist->new(
    lineup => "Finance::QuoteHist::Google",
    symbols => [$p], 
    start_date => '1 month ago', 
    end_date => 'today',);

print "\nquotes...\n";

my @quotes = ();

foreach $row ($q->quotes()) { 
    my ($sym, $date, $o, $h, $l, $c, $vol) = @$row;
    my ($yy, $mm, $dd) = split /\//, $date;
    my $epoch = DateTime->new(
                    year => $yy,
                    month => $mm,
                    day => $dd,
                    hour => 16, minute => 0, second => 0,
                    time_zone => 'America/New_York',
                 )->epoch;    
    push @quotes, pdl($epoch, $o, $h, $l, $c);
    print "@$row\n"; 
}

my $data = pdl(@quotes)->transpose;

print $data(0:-1,(1))."\n";

print $data(0:-1,(1))->movavg(7)."\n";