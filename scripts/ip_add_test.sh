#!/bin/bash

for "i" in {1..4}; do
   case "$i" in
   1) if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
        echo "<< ERROR: One of more paramaters are empty. USAGE: ip_add ipaddress username password vessel >>"
        exit 1
      fi
   ;;
   2) if [ -n "$5" ]; then
        echo "<< ERROR: Spaces found in vessel paramater. Please use underscores >>"
        exit 2
      fi
   ;;
   3) ping -c5 -t30 "$1" &> /home/e3admin/e3systems/logs/ping/"$1"
      check=$(grep "unknown host" /home/e3admin/e3systems/logs/ping/"$1")
      if [ -n "$check" ]; then
        echo "<< ERROR: IP address is not correct >>"
        exit 3
      fi
      ;;
   4) check=$(grep "5 packets transmitted, " /home/e3admin/e3systems/logs/ping/"$1" | cut -d" " -f3)
      if [ $check="0" ]; then
        echo "<< ERROR: Ping Timeout. IP address is possibly offline >>"
        exit 4
      fi
      ;;
   5) 
      ;;
   *) echo "Signal number $1 is not processed"
      ;;
   esac
done

exit
