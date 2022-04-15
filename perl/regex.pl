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

#negate match group (anything but):
qr/(?!bad),/

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


$arg =~ s[(?x)                    # free spacing mode, ignore whitespace and allow these comments
  (?<!\\)                         # a non-backslash, followed by
  ((?:\\\\)*+)                    # an even number of backslashes
  (?:(\\[bBgkNopPx]{)|
  {                               # an open brace
  (?!                             # *not* followed by...
          \d+                     # a number
          (?:,\d*)?               # an optional comma-number
          }                       # then a close brace
  )
  )
][ $1.($2 // '\\{') ]eg;            # if so, then insert a backslash


=head
  words:
    (?:one|two|3)   match any
    ((?!one).)*     don't match any, capturing
    (?:(?!:one).)*  don't match any, no capturing
  metacharacter classes:
    \d              digit
    \s              space or tab
    \w              word or number or _ [a-zA-Z0-9_]

  lookahead/lookbehind (source: https://stackoverflow.com/questions/2973436/regex-lookahead-lookbehind-and-atomic-groups)
    bar(?=bar)      finds the 1st bar ("bar" which has "bar" after it)
    bar(?!bar)      finds the 2nd bar ("bar" which does not have "bar" after it)
    (?<=foo)bar     finds the 1st bar ("bar" which has "foo" before it)
    (?<!foo)bar     finds the 2nd bar ("bar" which does not have "foo" before it)

  atomic groups:
    (?>foo)         matches the first possible greedy match and disables backtracking
=cut