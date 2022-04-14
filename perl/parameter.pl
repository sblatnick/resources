#Experimental Switch logic (pretty print):
#!/usr/bin/perl
use strict;
use experimental qw(switch);

$| = 1;

if(@ARGV==0) {
  print STDOUT qq~
Pretty Print virtually any ascii

  OPTIONS
    -f       File

~;
  exit 0;
}

my $file;
my $indent = 0;

while(my $arg = shift @ARGV) {
  given($arg) {
    when(/^(-f|--file)$/) { $file = shift @ARGV; }
    default {
      print STDOUT qq~Unknown parameter: "$arg"\n~;
      exit 1;
    }
  }
}

undef $/;
open(FILE, "<", $file) or die qq~Could not find "$file"~;
my $contents;
my $output;

while (<FILE>)
{
  $contents = $_;
  $contents =~ s/,\s*/,\n/sg;
  $contents =~ s/\n\n+/\n/sg;
  $contents =~ s/([\(\)\[\]\{\}])/\n$1\n/sg;
}
close(FILE);
$/ = "\n";

open(LINES, "<", \$contents) or die qq~Could not analyze by line~;
open(OUTPUT, ">", \$output) or die qq~Could not write to variable~;
while (<LINES>)
{
  my $line = $_;
  chomp($line);
  $indent-- if($line =~ /^[\)\]\}]$/);
  if($line ne "") {
    print OUTPUT ("  " x $indent) . $line . "\n";
  }
  $indent++ if($line =~ /^[\(\[\{]$/);
  #$block = /^\s*\w+\(/i .. /\);?\s*$/i

}
close(LINES);
close(OUTPUT);

undef $/;
open(REFLOW, "<", \$output) or die qq~Could not reflow lines~;
while (<REFLOW>)
{
  $contents = $_;
  $contents =~ s/\[\n\s*\]/[]\n/sg;
  $contents =~ s/\(\n\s*\)/()\n/sg;
  $contents =~ s/\{\n\s*\}/{}\n/sg;

  $contents =~ s/([=:])\n\s*([\(\[\{])/$1$2/sg;

  $contents =~ s/([\]\)\}])\n\s*,/$1,\n/sg;
  $contents =~ s/\n\n+/\n/sg;
}
$/ = "\n";
close(REFLOW);

print "$contents";

################################################################################
#Switch logic:
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

################################################################################
#Simple:
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

################################################################################
#getopts:
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

