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
      clear
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
      clear
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
   while [[ $yre != "yes" || "retry" || "exit" ]]; do
      clear
      echo "--------------------------------"
      echo "Vessel Name:         $vessel"
      echo "Vessel IP Address:   $ipaddress"
      echo "Vessel Username:     $username"
      echo "Vessel Password:     $password"
      echo "--------------------------------"
      read -p "Please enter \"yes\" to confirm above entered information, \"retry\" to re-enter information or \"exit\" to exit the application without saving any information" yre
   done
   if [[ $yre == "yes" || "exit" ]]; then
      $loop="no"
      clear
   fi
   case $yre in
      "yes")   counter=1 
               while [ $counter -le 4 ]; do
                  case "$counter" in
                  1) ping -c5 -t30 "$ipaddress" &> /home/e3admin/e3systems/logs/ping/"$ipaddress"
                     check=$(grep "unknown host" /home/e3admin/e3systems/logs/ping/"$ipaddress")
                     if [ -n "$check" ]; then
                        while [[ $output1 != "retry" || "exit" ]]; do
                           clear
                           echo "<< PING TEST ERROR: Unknown host ($ipaddress) >>"
                           read -p "Enter \"retry\" to re-enter information or \"exit\" to exit the application" output1
                           if [ output1 = "retry" ]; then
                              $loop="yes"
                              rm -rf /home/e3admin/e3systems/logs/ping/"$ipaddress"
                              counter=5
                           else
                              rm -rf /home/e3admin/e3systems/logs/ping/"$ipaddress"
                              exit 5
                           fi
                        done
                     fi
                     ;;
                  2) check=$(grep 'rtt' /home/e3admin/e3systems/logs/ping/"$1" | cut -d' ' -f2)
                     if [ -z "$check" ]; then
                        while [[ $output2 != "save" || "retry" || "exit" ]]; do
                           clear
                           echo "<< PING TEST ERROR: Timeout ($ipaddress) >>"
                           read -p "Enter \"save\" to save information anyways, \"retry\" to re-enter information or \"exit\" to exit the application" output2                        
                           case "output2" in
                           "save")  mysql e3db -ue3admin -pE3System5! -e "INSERT INTO \
                                       e3tb (IP_Address) \
                                       VALUES (\'$ipaddress\');"
                                    mysql e3db -ue3admin -pE3System5! -e "UPDATE e3tb SET \
                                       Vessel='$(echo "$vessel" | tr '[:upper:]' '[:lower:]' | sed "s/-/_/g" | sed "s/ /_/g")', \
                                       Ping_Min='ERROR', \
                                       Ping_Avg='ERROR', \
                                       Ping_Max='ERROR', \
                                       Packet_Loss='ERROR', \
                                       Latitude='ERROR', \
                                       Longitude='ERROR', \
                                       Rx_SNR='ERROR', \
                                       Rx_Raw_Reg='ERROR', \
                                       Rx_Raw_Reg_Lookup='ERROR', \
                                       Beam_ID='ERROR', \
                                       Beam_Name='ERROR' \
                                       WHERE IP_Address='$ipaddress';"                                       
                                    ;;
                           "retry") $loop="yes"
                                    rm -rf /home/e3admin/e3systems/logs/ping/"$ipaddress"
                                    counter=5
                                    ;;
                           "exit")  rm -rf /home/e3admin/e3systems/logs/ping/"$ipaddress"
                                    exit 6         
                           esac         
                        done
                     else
                        pingmin=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f4 | sed 's/ ms//g' | sed "s/rtt min\/avg\/max\/mdev = //")
                        pingavg=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f5 | sed 's/ ms//g')
                        pingmax=$(grep 'rtt min/avg/max/mdev = ' /home/e3admin/e3systems/logs/ping/"$1" | cut -d'/' -f6 | sed 's/ ms//g')
                        pktloss=$(grep 'packet loss' /home/e3admin/e3systems/logs/ping/"$1" | cut -d' ' -f6 | sed 's/%//g')
                     fi
                     ;;
                  3) /home/e3admin/e3systems/scripts/ip_tel.sh "$ipaddress" "$username" "$password" | tee /home/e3admin/e3systems/logs/raw/"$1"
                     lat=$( grep "latlong = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3-4 | sed 's/\r//g')
                     long=$( grep "latlong = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f5-6 | sed 's/\r//g' )
                     rxsnr=$( grep "Rx SNR: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3 | sed 's/\r//g' )
                     rxrr=$( grep "Rx raw reg: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f4 | sed 's/\r//g' )
                     rxrrl=$( grep "Rx raw reg lookup: " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f5 | sed 's/\r//g' )
                     beamid=$( grep " is currently selected" /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f1 | sed 's/\r//g' )
                     beamname=$( grep "$beamid = " /home/e3admin/e3systems/logs/raw/"$1" | cut -d" " -f3-20 | sed 's/\r//g' )
                     while [[ $output3 != "save" || "retry" || "exit" ]]; do
                        if [[ "$lat" && "$long" != *.* ]]; then
                           echo "<< TELNET TEST ERROR: Session failed ($ipaddress) >>"
                           read -p "Enter \"save\" to save information anyways, \"retry\" to re-enter information or \"exit\" to exit the application" output3
                           case "output3" in
                           "save")  mysql e3db -ue3admin -pE3System5! -e "INSERT INTO \
                                       e3tb (IP_Address) \
                                       VALUES (\'$ipaddress\');"
                                    mysql e3db -ue3admin -pE3System5! -e "UPDATE e3tb SET \
                                       Vessel='$(echo "$vessel" | tr '[:upper:]' '[:lower:]' | sed "s/-/_/g" | sed "s/ /_/g")', \
                                       Ping_Min='ERROR', \
                                       Ping_Avg='ERROR', \
                                       Ping_Max='ERROR', \
                                       Packet_Loss='ERROR', \
                                       Latitude='ERROR', \
                                       Longitude='ERROR', \
                                       Rx_SNR='ERROR', \
                                       Rx_Raw_Reg='ERROR', \
                                       Rx_Raw_Reg_Lookup='ERROR', \
                                       Beam_ID='ERROR', \
                                       Beam_Name='ERROR' \
                                       WHERE IP_Address='$ipaddress';"                                       
                                    ;;
                           "retry") $loop="yes"
                                    rm -rf /home/e3admin/e3systems/logs/raw/"$ipaddress"
                                    counter=5
                                    ;;
                           "exit")  rm -rf /home/e3admin/e3systems/logs/raw/"$ipaddress"
                                    exit 7         
                           esac                                 
                        fi
                     done   
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
                        VALUES (\'$ipaddress\');"
                     mysql e3db -ue3admin -pE3System5! -e "UPDATE e3tb SET \
                        Vessel='$(echo "$vessel" | tr '[:upper:]' '[:lower:]' | sed "s/-/_/g" | sed "s/ /_/g")', \
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
                        WHERE IP_Address='$ipaddress';"
                        ;;
                  esac
               done
               ;;
      "exit")  exit 8
               ;;
   esac
done
exit 0
