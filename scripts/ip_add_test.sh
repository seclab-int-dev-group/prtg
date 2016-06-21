#!/bin/bash
loop="yes"
while [ "$loop" = "yes" ]; do
   clear
   while [ -z $vessel ]; do
      clear
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"
      echo "<< 1) Leaving a blank input will prompt you to re-enter input >>"
      echo "<< 2) Entering \"q!\" will exit the application without saving any information >>"
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"
      read -p "Enter Vessel Name: " vessel
      if [ $vessel = "q!"]; then
         exit 1
      fi
   done
   while [ -z $ipaddress ]; do
      clear
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"
      echo "<< 1) Leaving a blank input will prompt you to re-enter input >>"
      echo "<< 2) Entering \"q!\" will exit the application without saving any information >>"
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"   
      read -p "Enter Vessel IP Address for $vessel: " ipaddress
      if [ $ipaddress = "q!"]; then
         exit 2
      fi      
   done
   while [ -z $username ]; do
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"
      echo "<< 1) Leaving a blank input will prompt you to re-enter input >>"
      echo "<< 2) Entering \"q!\" will exit the application without saving any information >>"
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"      
      read -p "Enter Telnet Username for $vessel ($ipaddress): " username
      if [ $username = "q!"]; then
         exit 3
      fi         
   done
   while [ -z $password ]; do
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"
      echo "<< 1) Leaving a blank input will prompt you to re-enter input >>"
      echo "<< 2) Entering \"q!\" will exit the application without saving any information >>"
      echo "<< ------------------------------------- >>"
      echo "<< -------- APPLICATION OPTIONS -------- >>"
      echo "<< ------------------------------------- >>"      
      read -p "Enter Telnet Password for $vessel ($ipaddress): " password
      if [ $password = "q!"]; then
         exit 4
      fi         
   done
   clear
   echo "--------------------------------"
   echo "Vessel Name:         $vessel"
   echo "Vessel IP Address:   $ipaddress"
   echo "Vessel Username:     $username"
   echo "Vessel Password:     $password"
   echo "--------------------------------"
   while [[ $yre != "confirm" || "retry" || "exit" ]]; do
      read -p "Please enter \"confirm\" to confirm above entered information, \"retry\" to re-enter information or \"exit\" to exit the application without saving any information" yre
   done
   if [[ $yre == "confirm" || "exit" ]]; then
      $loop="no"
   fi
done

   case $yre in
      "yes")   counter=1 
               while [ $counter -le 4 ]; do
                  case "$counter" in
                  1) ping -c5 -t30 "$ipaddress" &> /home/e3admin/e3systems/logs/ping/"$1"
                     check=$(grep "unknown host" /home/e3admin/e3systems/logs/ping/"$1")
                     if [ -n "$check" ]; then
                        echo "<< PING TEST ERROR: Unknown host ($ipaddress) >>"
                        exit 5
                     fi
                     ;;
                  2) check=$(grep 'rtt' /home/e3admin/e3systems/logs/ping/"$1" | cut -d' ' -f2)
                     if [ -z "$check" ]; then
                        echo "<< PING TEST ERROR: Timeout ($ipaddress) >>"
                        exit 6
                     else
                        pingmin=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f4 | sed 's/ ms//g' | sed "s/rtt min\/avg\/max\/mdev = //")
                        pingavg=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f5 | sed 's/ ms//g')
                        pingmax=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f6 | sed 's/ ms//g')
                        pktloss=$(grep 'packet loss' /home/e3admin/e3systems/logs/ping/"$1" | cut -d' ' -f6 | sed 's/%//g')
                     fi
                     ;;
                  3) /home/e3admin/e3systems/scripts/ip_tel.sh "$1" "$2" "$3" | tee /home/e3admin/e3systems/logs/raw/"$1"
                     lat=$( grep "latlong = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3-4 | sed 's/\r//g')
                     long=$( grep "latlong = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f5-6 | sed 's/\r//g' )
                     rxsnr=$( grep "Rx SNR: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3 | sed 's/\r//g' )
                     rxrr=$( grep "Rx raw reg: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f4 | sed 's/\r//g' )
                     rxrrl=$( grep "Rx raw reg lookup: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f5 | sed 's/\r//g' )
                     beamid=$( grep " is currently selected" /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f1 | sed 's/\r//g' )
                     beamname=$( grep "$beamid = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3-20 | sed 's/\r//g' )
                     if [[ "$lat" && "$long" != *.* ]]; then
                        echo "<< TELNET TEST ERROR: Session failed ($ipaddress) >>"
                        exit 7
                     fi
                     ;;
                  4) case "$lat" in
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
                        Vessel='$(echo "$4" | tr '[:upper:]' '[:lower:]' | sed "s/-/_/g" | sed "s/ /_/g")', \
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
               ;;
      "exit")  exit 8
               ;;
   esac
done
exit 0
