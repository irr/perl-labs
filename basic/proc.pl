use Proc::ProcessTable;
use YAML;

sub get_processes_info {
  my $pt = Proc::ProcessTable->new;
  my %info = map { $_->pid => $_ } @{$pt->table};
  return %info
}

my %info = get_processes_info();
  print Dump \%info;
