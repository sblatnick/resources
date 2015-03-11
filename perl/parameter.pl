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