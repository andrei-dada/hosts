#!/bin/bash

cat /etc/hosts | while read ip name rest
do
  case "$ip" in
    ""|\#*|*:*)
      continue
      ;;
  esac
  case "$name" in
    localhost|$(hostname))
      continue
      ;;
  esac
  realips=$(nslookup "$name" 8.8.8.8 2>/dev/null | grep "^Address" | grep -v "#" | awk '{print $2}')
  if ! echo "$realips" | grep -qx "$ip"; then
    echo "Bogus IP for $name in /etc/hosts!"
  fi
done
exit 0
