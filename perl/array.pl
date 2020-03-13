
#for loops should not modify array

#pop from array: (untested)
  my @search = qw(first second third);
  my @looking = @search; #copy since modifying in the for loop
  while (<IN>)
  {
    $line = $_;
    for my $str (@search) {
      if($line =~ m/^$str/) {
        pop @looking, $str;
      }
    }
    if($#looking eq 0) {
      close(IN);
      return 'True';
    }  
    @search = @looking;
  }
  close(IN)
  return 'False';