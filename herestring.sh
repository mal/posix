#!/bin/sh

# Emulate herestrings in dash. Uses --- instead of <<<
# usage: herestr grep <pattern> --- <string>

herestr()
{
  local count=$# i=1 use=

  for arg in "$@"; do
    test -n "$use" && local val="$arg" && break
    if [ "$arg" = '---' ]
      then local use=1
      else set -- "$@" "$arg"
    fi
  done

  shift $count

  if [ -z "$use" ]
    then "$@"
    else "$@" <<-EOF
			$val
		EOF
  fi
}

if ! herestr grep -q 'y' --- 'yes'
  then echo fail; exit 1
  else echo pass
fi
if herestr grep -q 'n' --- 'yes'
  then echo fail; exit 1
  else echo pass
fi
if herestr grep -q 'y' ---
  then echo fail; exit 1
  else echo pass
fi
