# pp -M Text::CSV_XS -M Finance::Quote::Yahoo::Brasil -M Finance::QuoteHist::Yahoo -M Finance::QuoteHist::Google -M PDL::NiceSlice::FilterUtilCall -o fetch fetch.pl

use DateTime;

use Finance::Quote;
use Finance::QuoteHist;

use Math::Business::SMA;
use Math::Business::ParabolicSAR;
use GD::Graph::mixed;
use List::Util ();

use PDL;
use PDL::NiceSlice;
use PDL::Finance::TA ':Func';

use constant DAYS => 7;

my $p = ($#ARGV < 0) ? "PETR4" : $ARGV[0];

print "\nRetrieving quote (realtime)...\n";

my $q = Finance::Quote->new("Yahoo::Brasil");
$q->timeout(60);
$q->set_currency("BRL");
 
my %info = $q->fetch("yahoo_brasil", $p);

foreach (qw(close open last date time exchange bid volume high low pe p_change name success)) {
    print "$_: $info{$p, $_}, ";
}

print "\n\nRetrieving quotes (historical)...\n";

$q = Finance::QuoteHist->new(
    lineup => "Finance::QuoteHist::Google",
    symbols => [$p], 
    start_date => '1 month ago', 
    end_date => 'today',);

my @quotes = $q->quotes();

my @pdlquotes = ();
my @cells = ();

my $sar = Math::Business::ParabolicSAR->recommended;
my @graphdata;

foreach $row (@quotes) { 
    my ($sym, $date, $o, $h, $l, $c, $vol) = @$row;
    my ($yy, $mm, $dd) = split /\//, $date;
    my $epoch = DateTime->new(
                    year => $yy,
                    month => $mm,
                    day => $dd,
                    hour => 16, minute => 0, second => 0,
                    time_zone => 'America/New_York',
                 )->epoch;    
    push @pdlquotes, pdl($epoch, $o, $h, $l, $c);
    push @cells, $o;
    
    my $p = [$o, $h, $l, $c];
    $sar->insert(@p);

    push @{$graphdata[0]}, $dd;     # date
    push @{$graphdata[1]}, $p->[3]; # close
    push @{$graphdata[2]}, $p->[1]; # high
    push @{$graphdata[3]}, $p->[2]; # low
    push @{$graphdata[4]}, $sar->query;

    print "@$row\n"; 
}

print "\nPDL processing quotes (SMA)...\n";

my $data = pdl(@pdlquotes)->transpose;

print $data(0:-1,(1))."\n\n";

print "PDL(SMA): ".$data(0:-1,(1))->movavg(DAYS)."\n";

print "\nMath::Business processing quotes (SMA)...\n";

my @smas = ();
my $limit = $#cells + 1 - DAYS;

for (my $i = 0; $i <= $limit; $i++) {
    my @d = @cells[$i..($i + DAYS - 1)];
    my $avg = new Math::Business::SMA(DAYS);    
    $avg->insert($_) for @d;
    push @smas, $avg->query;
}

print "MB (SMA): [ @smas]\n";

my @all_points = grep {defined $_} map {@$_} @graphdata[1 .. $#graphdata];

my $min_point  = List::Util::min(@all_points);
my $max_point  = List::Util::max(@all_points);

my $graph = GD::Graph::mixed->new(1000, 500);
   $graph->set(
       y_label           => 'dollars',
       x_label           => 'date',
       transparent       => 0,
       markers           => [qw(7 3 9 8)],
       dclrs             => [qw(black lgreen lred lblue)],
       y_min_value       => $min_point-0.2,
       y_max_value       => $max_point+0.2,
       y_number_format   => '%0.2f',
       x_labels_vertical => 1,
       types             => [qw(linespoints points points points)],
 
   ) or die $graph->error;
 
my $gd = $graph->plot(\@graphdata) or die $graph->error;
open my $img, '>', "/tmp/sar.png" or die $!;
binmode $img;
print $img $gd->png;
close $img;

exec "eog /tmp/sar.png &> /dev/null && rm -rf /tmp/sar.png" ;
