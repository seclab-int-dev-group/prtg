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
        echo "<< ERROR: Ping Timeout. Unable to reach IP address >>"
        exit 4
      fi
      ;;
   5) /home/e3admin/e3systems/scripts/ip_tel.sh "$1" "$2" "$3" | tee /home/$user/e3systems/logs/raw/"$1"
      lat=$( grep "latlong = " $rawlog/$1 | cut -d" " -f3-4 | sed 's/\r//g')
      long=$( grep "latlong = " $rawlog/$1 | cut -d" " -f5-6 | sed 's/\r//g' )
      rxsnr=$( grep "Rx SNR: " $rawlog/$1 | cut -d" " -f3 | sed 's/\r//g' )
      rxrr=$( grep "Rx raw reg: " $rawlog/$1 | cut -d" " -f4 | sed 's/\r//g' )
      rxrrl=$( grep "Rx raw reg lookup: " $rawlog/$1 | cut -d" " -f5 | sed 's/\r//g' )
      beamid=$( grep " is currently selected" $rawlog/$1 | cut -d" " -f1 | sed 's/\r//g' )
      beamname=$( grep "$beamid = " $rawlog/$1 | cut -d" " -f3-20 | sed 's/\r//g' )
      if [ "$lat" -ne "*.*" ] && [ "$long" -ne "*.*" ]; then
         echo "<< ERROR: Unable to complete telnet session >>"
         exit 5
      fi
      ;;
   6) mysql e3db -ue3admin -pE3System5! -e "INSERT INTO \
         e3tb (IP_Address) \
         VALUES (\'$1\');"
      mysql e3db -ue3admin -pE3System5! -e "INSERT INTO \
         e3tb (Vessel) \
         VALUES ('$(echo "$4" | tr '[:upper:]' '[:lower:]' | sed "s/-/_/g")') \
         WHERE IP_Address=\"$1\";"
      mysql e3db -ue3admin -pE3System5! -e "UPDATE e3tb SET \
         Ping='$ping', \
         Packet_loss='$pktloss', \
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

exit
