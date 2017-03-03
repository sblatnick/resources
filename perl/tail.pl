#!/usr/bin/perl
use File::Tail;

if(@ARGV == 0) {
  print "Usage: tailor [file]\n";
  exit();
}

my $file = $ARGV[0];

my $ref=tie *FH,"File::Tail",(name=>"$file",interval=>1,maxinterval=>1);
while (<FH>) {
  my $line = $_;
  $line =~ s/.*VerboseDBI.*//g;
  if($line != "") {
    print "$line\n";
  }
}
