#!/usr/bin/perl

use strict;
use Switch;

$| = 1;

#defaults:
my $fetch = -1;
my $execute = -1;
my $clients = 'clients.csv';
my $domains = 'domain.csv';
my $revert = 'revert.sql';
my $logger;

if(@ARGV==0) {
  print STDOUT qq~
  Basic Description

  OPTIONS
  
    REQUIRED:
      --dry-fetch     Don't actually run
      --fetch         Fetch [file] blah
  
  \n~;
  exit 0;
}

while(my $arg = shift @ARGV) {
  switch($arg) {
    case "--dry-fetch" {$fetch = 0;}
    case "--dry-exe" {$execute = 0;}
    case "--fetch" {$fetch = 1;}
    case "--execute" {$execute = 1;}
    case "--client" {$clients = shift @ARGV;}
    case "--log" {$logger = shift @ARGV;}
    case "--revert" {$revert = shift @ARGV;}
    case "--domain" {$domains = shift @ARGV;}
    else {
      print STDOUT qq~Unknown parameter: "$arg"\n~;
      exit 0;
    }
  }
}

if($fetch == -1 && $execute == -1) {
  print STDOUT "Required parameter missing\n";
  exit 0;
}

if(defined $logger) {
  open(STDOUT, ">$logger");
}


#function/sub parameter:
sub subName
{
  my $parameter = shift;
}

###Simple:

#!/usr/bin/perl

use strict;
if(@ARGV==0)
{
  usage();
  exit();
}

my $i = 0;
foreach my $parm (@ARGV)
{
  print "parameter $i: ", $ARGV[$i], "\n";
  $i++;
}
exit(0);

sub usage
{
  print "Usage: program [blah]\n";
}

###getopts:

#!/usr/bin/perl

use strict;
use Switch;
use DBI;
use V4::DBBroker;
use Getopt::Long;
use Pod::Usage;

$| = 1;

my $man = 0;
my $help = 0;
my $type = '';

GetOptions
(
  'type=s' => \$type,
  'help|?' => \$help,
  man => \$man
)
or pod2usage(2);
pod2usage(-exitstatus => 0, -verbose => 2) if $man;
pod2usage(1) if $help || $type eq '';

__END__
=head1 NAME

sample - Using Getopt::Long and Pod::Usage

=head1 SYNOPSIS

sample [options] [file ...]
  Options:
    -help brief help message
    -man full documentation
=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do something
useful with the contents thereof.

=cut

