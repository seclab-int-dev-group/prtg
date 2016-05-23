#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for pulling geolocation data.
# USAGE:            Edit the variables with desired configuration and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables.
user=""                                                # User scripts will run under.
db="e3db"                                              # MySQL database name.
table="e3tb"                                           # MySQL table name.
dbuser=""                                              # MySQL database username
dbpass=""                                              # MySQL database password
outlog="/home/$user/e3systems/logs/output/"            # Output log file location.
rawlog="/home/$user/e3systems/logs/raw/"               # Raw log file location.
telnet="/home/$user/e3systems/scripts/ip_tel.sh"       # Telnet script location.

###############################################################################################################################

# Open telnet session to modem, pull output of commands into temporary file on host, then close telnet session.
$telnet $1 $2 $3 | tee $rawlog/$1

# Make log entry with IP address of modem.
echo $1 > $outlog/$1

# Grab latitude data from temporary file,populate variable named lat and make log entry.
lat=$( grep "latlong = " $rawlog/$1 | cut -d" " -f3-4 | sed 's/\r//g')
grep "latlong = " $rawlog/$1 | cut -d" " -f3-4 | sed 's/\r//g' >> $outlog/$1

# Grab longitude data from temporary file, populate variable named long and make log entry.
long=$( grep "latlong = " $rawlog/$1 | cut -d" " -f5-6 | sed 's/\r//g' )
grep "latlong = " $rawlog/$1 | cut -d" " -f5-6 | sed 's/\r//g' >> $outlog/$1

# Grab Rx SNR data from temporary file, populate variable named rxsnr and make log entry.
rxsnr=$( grep "Rx SNR: " $rawlog/$1 | cut -d" " -f3 | sed 's/\r//g' )
grep "Rx SNR: " $rawlog/$1 | cut -d" " -f3 | sed 's/\r//g' >> $outlog/$1

# Grab Rx reg raw data from temporary file, populate variable named rxrr and make log entry.
rxrr=$( grep "Rx raw reg: " $rawlog/$1 | cut -d" " -f4 | sed 's/\r//g' )
grep "Rx raw reg: " $rawlog/$1 | cut -d" " -f4 | sed 's/\r//g' >> $outlog/$1

# Grab Rx reg raw lookup data from temporary file, populate variable named rxrrl and make log entry.
rxrrl=$( grep "Rx raw reg lookup: " $rawlog/$1 | cut -d" " -f5 | sed 's/\r//g' )
grep "Rx raw reg lookup: " $rawlog/$1 | cut -d" " -f5 | sed 's/\r//g' >> $outlog/$1

# Grab selected beam from temporary file, find corresponding beam, populate variable named beam and make log entry.
beamint=$( grep " is currently selected" $rawlog/$1 | cut -d" " -f1 | sed 's/\r//g' )
grep " is currently selected" $rawlog/$1 | cut -d" " -f1 | sed 's/\r//g' >> $outlog/$1
beamstr=$( grep "$beamint = " $rawlog/$1 | cut -d" " -f3-20 | sed 's/\r//g' )
grep "$beamint = " $rawlog/$1 | cut -d" " -f3-20 | sed 's/\r//g' >> $outlog/$1

# Insert data from above variables into MySQL database table.
mysql $db -u$dbuser -p$dbpass -e "UPDATE $table SET \
Ping='$ping', \
Packet_loss='$pktloss', \
Latitude='$lat', \
Longitude='$long', \
Rx_SNR='$rxsnr', \
Rx_raw_reg='$rxrr', \
Rx_raw_reg_lookup='$rxrrl', \
Beam_Int='$beamint', \
Beam_Str='$beamstr' \
WHERE IP_Address='$1';"

exit 0
