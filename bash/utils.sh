#::::::::::::::::::::CUT::::::::::::::::::::

  cut
    -d #delimiter
    -f #field

  #examples:
    #field 2:
    cut -f2 -d' ' <<< "hello world and everybody in it"
      world
    #field 2 and on:
    cut -f2- -d' ' <<< "hello world and everybody in it"
      world and everybody in it
    #all fields up to 2:
    cut -f-2 -d' ' <<< "hello world and everybody in it"
      hello world
    #last field:
    echo "hello world and everybody in it" | rev | cut -d' ' -f 1-2 | rev
      in it

#::::::::::::::::::::REV::::::::::::::::::::

#reverse any string:
  echo "hello world and everybody in it" | rev
    ti ni ydobyreve dna dlrow olleh
#print file in reverse:
  rev file.txt
    dlrow olleh

#::::::::::::::::::::CAT::::::::::::::::::::

#concatenate and print files
  cat file1.txt file2.txt

#::::::::::::::::::::TAC::::::::::::::::::::

#reverse print lines of file

#Mac alias:
alias tac="tail -r"

#::::::::::::::::::::ZIP::::::::::::::::::::

#compress:
tar -czvf archive.tar.gz ./directory
#decompress:
tar -zxvf filename.tgz