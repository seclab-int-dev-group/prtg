#!/bin/bash

###############################################################################################################################
#DESCRIPTION:       A custom ping script for compatibility with PRTG Network Monitor.
#USAGE:             Edit the variables with desired configuration.
#CREATED BY:        William Thomas Bland.
###############################################################################################################################

# Declare variables.
user=""
db=""           # MySQL database name.
table=""        # MySQL table name.
dbuser=""    # MySQL database username
dbpass="" # MySQL database password
pinglog="/home/$user/prtg/logs/ping"

###############################################################################################################################

# Populate log file returned ping output.
ping -c1 "$1" > $pinglog/"$1"

# Populate ping variable with current ping returned.
ping=$(grep 'time=' $pinglog/"$1" | cut -d'=' -f4 | sed 's/ ms//g')

# Populate packet loss variable with current packet loss returned.
pktloss=$(grep 'packet loss' $pinglog/"$1" | cut -d' ' -f6 | sed 's/%//g')

# Output returned value to mysql database
mysql $db -u$dbuser -p$dbpass -e "UPDATE $table SET Ping='$ping', Packet_loss='$pktloss' WHERE IP_Address='$1';"

exit 0
