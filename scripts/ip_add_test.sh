#!/bin/bash

for i in {1..6}; do
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
   4) check=$(grep 'rtt' /home/e3admin/e3systems/logs/ping/"$1" | cut -d' ' -f2)
      if [ -z "$check" ]; then
         echo "<< ERROR: Ping Timeout. Unable to reach IP address >>"
         exit 4
      else
         pingmin=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f4 | sed 's/ ms//g' | sed "s/rtt min\/avg\/max\/mdev = //")
         pingavg=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f5 | sed 's/ ms//g')
         pingmax=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f6 | sed 's/ ms//g')
         pktloss=$(grep 'packet loss' /home/e3admin/e3systems/logs/ping/"$1" | cut -d' ' -f6 | sed 's/%//g')
      fi
      ;;
   5) /home/e3admin/e3systems/scripts/ip_tel.sh "$1" "$2" "$3" | tee /home/e3admin/e3systems/logs/raw/"$1"
      lat=$( grep "latlong = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3-4 | sed 's/\r//g')
      long=$( grep "latlong = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f5-6 | sed 's/\r//g' )
      rxsnr=$( grep "Rx SNR: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3 | sed 's/\r//g' )
      rxrr=$( grep "Rx raw reg: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f4 | sed 's/\r//g' )
      rxrrl=$( grep "Rx raw reg lookup: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f5 | sed 's/\r//g' )
      beamid=$( grep " is currently selected" /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f1 | sed 's/\r//g' )
      beamname=$( grep "$beamid = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3-20 | sed 's/\r//g' )
      if [[ "$lat" && "$long" != *.* ]]; then
         echo "<< ERROR: Unable to complete telnet session >>"
         exit 5
      fi
      ;;
   6) case "$lat" in
      N) lat="${lat/ N//}"
         ;;
      S) lat=-"${lat/ S//}"
         ;;
      esac
      case "$long" in
      E) long="${long/ E//}"
         ;;
      W) long=-"${long/ W//}"
         ;;
      esac
      mysql e3db -ue3admin -pE3System5! -e "INSERT INTO \
         e3tb (IP_Address) \
         VALUES (\'$1\');"
      mysql e3db -ue3admin -pE3System5! -e "UPDATE e3tb SET \
         Vessel='$(echo "$4" | tr '[:upper:]' '[:lower:]' | sed "s/-/_/g")', \
         Ping_Min='$pingmin', \
         Ping_Avg='$pingavg', \
         Ping_Max='$pingmax', \
         Packet_Loss='$pktloss', \
         Latitude='$lat', \
         Longitude='$long', \
         Rx_SNR='$rxsnr', \
         Rx_Raw_Reg='$rxrr', \
         Rx_Raw_Reg_Lookup='$rxrrl', \
         Beam_ID='$beamid', \
         Beam_Name='$beamname' \
         WHERE IP_Address='$1';"
      ;;
   esac
done

exit 0
