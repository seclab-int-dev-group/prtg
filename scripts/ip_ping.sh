#!/bin/bash

###############################################################################################################################
#DESCRIPTION:     A custom ping script for compatibility with PRTG Network Monitor.
#USAGE:           Edit the variables with desired configuration.
#CREATED BY:      William Thomas Bland.
###############################################################################################################################

# Declare variables.
user=""          # User scripts will run under.
db="e3db"         # MySQL database name.
table="e3tb"      # MySQL table name.
dbuser=""         # MySQL database username
dbpass=""         # MySQL database password
pinglog="/home/$user/e3systems/logs/ping"

###############################################################################################################################

# Populate log file returned ping output.
ping -c5 -t30 "$1" &> $pinglog/"$1"

check=$(grep 'unknown host' $pinglog/"$1")
check=$(grep '5 packets transmitted, ' $pinglog/"$1" | cut -d' ' -f3)

if [ -n $check ]; then

  echo "<< IP address is not correct >>"

else
  
  if [ $check="0" ]; then

    # Populate ping variable with current ping returned.
    ping="Timed out"
    # Populate packet loss variable with current packet loss returned.
    pktloss=$(grep 'packet loss' $pinglog/"$1" | cut -d' ' -f6 | sed 's/%//g')

  else
  
    # Populate ping variable with current ping returned.
    ping=$(grep 'rtt min/avg/max/mdev = ' $pinglog/"$1" | cut -d'/' -f5 | sed 's/ ms//g')
  
    # Populate packet loss variable with current packet loss returned.
    pktloss=$(grep 'packet loss' $pinglog/"$1" | cut -d' ' -f6 | sed 's/%//g')
  
  fi

  # Output returned value to mysql database
  mysql $db -u$dbuser -p$dbpass -e "UPDATE $table SET Ping='$ping', Packet_loss='$pktloss' WHERE IP_Address='$1';"

fi

exit 0
