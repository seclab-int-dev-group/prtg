#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for creating MYSQL database.
# USAGE:            Edit the variables with desired configuration and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables
db="e3db"           # MySQL database name.
table="e3tb"        # MySQL table name.
dbuser="e3admin"    # MySQL database username
dbpass="E3System5!" # MySQL database password

###############################################################################################################################

# Create MYSQL database table.
mysql $db -u$dbuser -p$dbpass -e "CREATE TABLE $table (\
IP_Address VARCHAR(16) PRIMARY KEY, \
Vessel VARCHAR(100), \
Ping VARCHAR(50), \
Packet_Loss VARCHAR(50), \
Latitude VARCHAR(50), \
Longitude VARCHAR(50), \
Rx_SNR VARCHAR(50), \
Rx_Raw_Reg VARCHAR(50), \
Rx_Raw_Reg_Lookup VARCHAR(50), \
Beam_ID VARCHAR(50), \
Beam_Name VARCHAR(100));"

exit 0
