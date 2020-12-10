#!/bin/bash
export PATH="${PATH}:${RESOURCES}/path:${HOME}/.krew/bin:/usr/sbin"

function extract()
{
  if [ $# -lt 1 ];then
    echo "extract [archive.zip|jar]"
    return 1
  fi
  archive=$1
  
  if [ -f ${archive} ];then
    if [ -d ${archive%.*} ];then
      rm -rf ${archive%.*} 2>/dev/null
    fi
    mkdir ${archive%.*}
    tar -xvzf ${archive} -C ${archive%.*}
  else
    echo "no such archive: ${archive}"
    return 1
  fi
}

function search()
{
  pattern=$1
  shift
  find -L . -type d | sed 's/$/\//' | ag ${pattern}
  find -L . -type f | ag ${pattern}
}

function jag()
{
  if [ $# -lt 1 ];then
    echo "jag [pattern]"
    echo "  Java Ag - Search all jars for files matching pattern"
    return 1
  fi
  pattern=$1
  find . -type f -name "*.jar" -print0 | xargs -0 -n 1 -I {} bash -c "jar -tf {} | grep -E ${pattern} && echo 'file: {}'" _ {}
}

#~ function sir()
#~ {
  #~ trap "echo 'matched lines in place sed and replace
#~ Usage: sir [match] [search] [replace]';return 1" ERR

  #~ local match="$1"
  #~ shift
  #~ local search="$1"
  #~ shift
  #~ local replace="$1"
  #~ shift

  #~ for file in $(ag -l ${match})
  #~ do
    #~ echo -e "\033[33mupdating: (s)\033[0m ${file}"
    #~ sed -i '/${match//\//\\/}/ s/${search//\//\\/}/${replace//\//\\/}/' ${file}
  #~ done
#~ }

#~ function surly() {
  #~ trap "echo 'delete matching lines
#~ Usage: surly [match]';return 1" ERR

  #~ local match=$1
  #~ shift

  #~ for file in $(ag -l ${match})
  #~ do
    #~ echo -e "\033[33mremoving lines: (s)\033[0m ${file}"
    #~ sed -i '/${match//\//\\/}/d' ${file}
  #~ done
#~ }
