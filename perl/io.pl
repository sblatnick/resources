#!/usr/bin/env perl

#by line:
  use warnings;
  use strict;

  open(my $input, "<", "file.txt") or die "Could not find \"file.txt\"";
  while (<$input>)
  {
    my $line = $_;
  }
  close($input);

#IN and OUT:
  open(IN, "<", "in.txt") or die "Could not find \"in.txt\"";
  open(OUT, ">", "out.txt") or die "Could not find \"out.txt\"";

  while (<IN>)
  {
    my $line = $_;
    if($line =~ m/^error/) {
      print OUT "!!!!" . $line;
    }
    else {
      print OUT $line;
    }  
  }
  close(IN);
  close(OUT);

#rename:
  rename('/home/steve/work/lcta/env/blank/schema.sql.2', '/home/steve/work/lcta/env/blank/schema.sql');

#whole file:
  undef $/;      # read in whole file, not just one line or paragraph
  while ( <> ) {
    while ( /START(.*?)END/sgm ) { # /s makes . cross line boundaries
        print "$1\n";
    }
  }
  $/ = "\n"; #Read file line by line again from here on


#Concat files to a 400 file
use Fcntl qw(O_WRONLY O_CREAT);
#Args: self, output, input...
sub _concat {
  my ($self, @arg) = @_;
  my $output = shift @arg;
  print STDOUT "cat ";
  foreach my $input (@arg) {
    print STDOUT "$input ";
  }
  print STDOUT "> $output\n";
  sysopen(my $out, $output, O_WRONLY | O_CREAT, 0400) or die "Couldn't open '$output': $!";

  foreach my $input (@arg) {
    open(my $in, "<", $input) or die "Couldn't open '$input': $!";
    while (my $line = <$in>) {
      print $out $line;
    }
    close $in;
  }
  close $out;
}