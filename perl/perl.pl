my @array = ($contentString =~ /regexwith(Parenthesis)/gims);

while(($key, $value) = each %hash) {
  print "key: $key, value: $hash{$key}\n";
}

#matching:
if ($sentence =~ /under/)

#check for installed modules from bash:
perldoc -l Encode::Guess

#simple parameter:
sub subName
{
    my $parameter = shift;

#sub caller information:
my ($package, $filename, $line) = caller;
print STDERR "\033[33mfrom: $package -> $filename:$line\033[0m\n";

foreach $element (@array){
  print "$element\n";
}

for my $i ( 0 .. $#array ) {
  print "$i: $array[$i]\n";
}

$str =~ s/was/replace/;

#exception handling:
eval {
  die "error";
};
if($@) {
  print $@;
}

#escalate warning to exception:
local $SIG{__WARN__} = sub {
  die @_;
};
eval {
  warn "There was a warning message here"; #could be passed from sub too
};
if($@) {
  print "ERROR: $@\n";
}

#array reference handling: http://perldoc.perl.org/perlref.html
  use JSON qw( from_json );
  my @users = @{from_json get("https://restapi.com/customer/2/users")};
  my $location = 'null';
  #first user's location:
  if(ref(@users) eq 'ARRAY' && exists $users[0] && $users[0]->{'location'}) {
    $location = $users[0]->{'location'};
  }
  else {
    print Dumper(@users);
  }