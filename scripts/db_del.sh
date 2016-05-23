#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for clearing data from MYSQL database.
# USAGE:            Edit the variables with desired configuration and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables.
db="e3db"           # MySQL database name.
table="e3tb"        # MySQL table name.
dbuser=""           # MySQL database username.
dbpass=""           # MySQL database password.

###############################################################################################################################

# Clear MySQL database table data.
mysql $db -u$dbuser -p$dbpass -e "DELETE FROM $table;"

exit 0
