#!/usr/bin/perl

#capture an array of matches:
my @array = ($contentString =~ /regexwith(Parenthesis)/gims);
#get first match:
my ($variable) = $contentString =~ /regexwith(parenthesis)/ims;

#replace:
$replace =~ s/\n/ /sg;
$replace =~ s/(capture)/<$1>/sg;

#find match:
if ($match =~ /under/)

#AND regex logic:
$contentString =~ /(?=.*filename=".{8}\.zip";)(?=.*size=12561)/s;
#In Java, flags are set before (http://kodejava.org/how-do-i-write-embedded-flag-expression/):
# (?s)(?=.*filename=".{8}\.zip";)(?=.*size=12561)

#qr are passable, pre-compiled regular expressions
#reset $1 with each or by using "(?|" (perl >5.10.0)
qr/(?|from=<([^>]+)>,src=|^\s+Sender:(.*?)$)/
#get next match group? (I'm not sure):
$+

#named capture groups:
$test =~ /(?<variable>\w{4})(?<example>\w{4})/;

say 'variable:', $+{variable};
say 'example:', $+{example};