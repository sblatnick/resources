#!/bin/bash
export PATH="$PATH:$HOME/projects/resources/path/"
export LESS="${LESS}R"

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