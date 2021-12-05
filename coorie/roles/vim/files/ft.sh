#!/bin/bash

function main(){
  local body=`cat "$1"`
  local bak=`cat "$2"`
  local new=`echo "$body"| reduce "$3"`
  if [ "$new" = "$body" ]; then
    echo 'unchanged'
    return 0
  fi
  echo "$body" > "$2"
  echo "$new" > "$1"
  if ! valid "$1"; then
    echo "$body" > "$1"
    local tmp=`mktemp`
    echo "$new" > $tmp
    echo $tmp
    return 1
  fi
}

function reduce(){
  local found=''
  local n=1
  while read -r l; do
    if [ $found ]; then
      if [ "$l" = "" ]; then
        found=''
      fi
    else
      IFS=$'\n'
      for q in `echo "$1"`; do
        if [ "\" $q" = "$l" ]; then
          found='found'
          break
        fi
      done
      if ! [ $found ]; then
        echo "$l"
      fi
    fi
    n=`expr $n + 1`
  done
}

function valid(){
  local out=`nvim --headless -c message -c q 2>&1`
  if echo "$out" | grep "$1" > /dev/null; then
    return 1
  else
    return 0
  fi
}

main "$1" "$2" "$3"
