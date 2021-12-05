#!/bin/bash

function main(){
  local body=`cat "$1"`
  local new=`echo "$body"| _main "$2"`
  if [ "$new" = "$body" ]; then
    echo 'unchanged'
    return 0
  fi
  echo "$new" > "$1"
  if ! valid "$1"; then
    echo "$body" > "$1"
    local tmp=`mktemp`
    echo "$new" > $tmp
    echo $tmp
    return 1
  fi
}

function _main(){
  local found=''
  local n=1
  IFS=$'\n'
  while read -r l; do
    if [ $found ]; then
      if [ "$l" = "" ]; then
        found=''
      else
        echo -n '"'
      fi
    else
      IFS=$'\n'
      for q in `echo "$1"`; do
        if [ "\" $q" = "$l" ]; then
          found='found'
          echo -n '"'
          break
        fi
      done
    fi
    echo "$l"
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

main "$1" "$2"
