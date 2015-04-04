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
	undef $/;  		# read in whole file, not just one line or paragraph
	while ( <> ) {
		while ( /START(.*?)END/sgm ) { # /s makes . cross line boundaries
				print "$1\n";
		}
	}
	$/ = "n"; #Read file line by line again from here on
