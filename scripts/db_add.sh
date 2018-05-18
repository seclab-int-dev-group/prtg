#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for creating MYSQL database.
# USAGE:            Edit the variables with desired configuration and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables
db=""           # MySQL database name.
table=""        # MySQL table name.
dbuser=""    # MySQL database username
dbpass="" # MySQL database password

###############################################################################################################################

# Create MYSQL database table.
mysql $db -u$dbuser -p$dbpass -e "CREATE TABLE $table (\
IP_Address VARCHAR(16) PRIMARY KEY, \
Name VARCHAR(100), \
Ping VARCHAR(50), \
Packet_loss VARCHAR(50), \
Latitude VARCHAR(50), \
Longitude VARCHAR(50), \
Rx_SNR VARCHAR(50), \
Rx_raw_reg VARCHAR(50), \
Rx_raw_reg_lookup VARCHAR(50), \
Beam_Int VARCHAR(50), \
Beam_Str VARCHAR(100));"

exit 0
