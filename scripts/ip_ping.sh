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

until [ -n "$ping" ] && [ -n "$pktloss" ]; do 

  # Populate log file returned ping output.
  ping -c1 "$1" > $pinglog/"$1"

  # Populate ping variable with current ping returned.
  ping=$(grep 'time=' $pinglog/"$1" | cut -d'=' -f4 | sed 's/ ms//g')

  # Populate packet loss variable with current packet loss returned.
  pktloss=$(grep 'packet loss' $pinglog/"$1" | cut -d' ' -f6 | sed 's/%//g')

done

# Output returned value to mysql database
mysql $db -u$dbuser -p$dbpass -e "UPDATE $table SET Ping='$ping', Packet_loss='$pktloss' WHERE IP_Address='$1';"

exit 0
