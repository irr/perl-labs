# pp -M Text::CSV_XS -M Finance::Quote::Yahoo::Brasil -M Finance::QuoteHist::Yahoo -M Finance::QuoteHist::Google -o fetch fetch.pl

use Finance::Quote;
use Finance::QuoteHist;

my $q = Finance::Quote->new("Yahoo::Brasil");
$q->timeout(60);
$q->set_currency("BRL");
 
my %info = $q->fetch("brasil", "PETR4");

foreach (qw(close open last date time exchange bid volume high low pe p_change name success)) {
    print "$_: $info{'PETR4', $_}, ";
}

$q = Finance::QuoteHist->new(
    symbols => [qw(PETR4)], 
    start_date => '1 month ago', 
    end_date => 'today',);

print "quotes...\n";

foreach $row ($q->quotes()) { 
    my ($symbol, $date, $open, $high, $low, $close, $volume) = @$row; 
    print "@$row\n"; 
}

# name         Company or Mutual Fund Name
# last         Last Price
# high         Highest trade today
# low          Lowest trade today
# date         Last Trade Date  (MM/DD/YY format)
# time         Last Trade Time
# net          Net Change
# p_change     Percent Change from previous day's close
# volume       Volume
# avg_vol      Average Daily Vol
# bid          Bid
# ask          Ask
# close        Previous Close
# open         Today's Open
# day_range    Day's Range
# year_range   52-Week Range
# eps          Earnings per Share
# pe           P/E Ratio
# div_date     Dividend Pay Date
# div          Dividend per Share
# div_yield    Dividend Yield
# cap          Market Capitalization
# ex_div       Ex-Dividend Date.
# nav          Net Asset Value
# yield        Yield (usually 30 day avg)
# exchange     The exchange the information was obtained from.
# success      Did the stock successfully return information? (true/false)
# errormsg     If success is false, this field may contain the reason why.
# method       The module (as could be passed to fetch) which found this
#              information.
# type         The type of equity returned
