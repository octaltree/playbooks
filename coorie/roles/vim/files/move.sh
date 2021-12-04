#!/bin/bash

path="$1"
dir=`dirname "$path"`
fileName=`basename "$path"`
root=`dirname "$dir"`
dirName=`basename "$dir"`
newDir="${root}/_${dirName}"
newPath="${newDir}/${fileName}"

if [ -f "$path" ]; then
  if ! [ -d "$newDir" ]; then
    mkdir -p "$newDir"
  fi
  mv "$path" "$newPath"
else
  echo unchanged
fi
