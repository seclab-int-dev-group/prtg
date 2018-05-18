#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for removing and IP address from crontab.
# USAGE:            un script with IP address set as argument and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables.
user=""
db=""           # MySQL database name.
table=""        # MySQL table name.
dbuser=""    # MySQL database username.
dbpass="" # MySQL database password.

###############################################################################################################################

# Check if option is populated.
if [ -z "$1" ]; then

  # Output error if option is not populated.
  echo "<< Invalid entry - Correct usage >>: ipdel [ipaddress]"
  
else
  
  # Populate variable with line containing IP address in crontab or set as blank if no IP address is found.
  check=$(grep "$1" /etc/crontab)

  # Check if variable is blank.
  if [ -z "$check" ]; then

    # Output error if variable is blank.
    echo "<< No IP address matching $1 found in schedule >>"

  else

    # Remove line in crontab corresponding to IP address set as argument.
    sudo sed -i '/'$1'/d' /etc/crontab

    # Remove log files corresponding to IP address set as argument.
    rm -f /home/$user/prtg/logs/*/$1
    
    # Remove corresponding database row.
    mysql $db -u$dbuser -p$dbpass -e "DELETE FROM $table WHERE IP_Address='$1';"

    sed -i "/<!-- START SET $1 -->/,/<!-- END SET $1 -->/d" /var/www/html/map/map-global.html
    sed -i "/<!-- START SET $1 -->/,/<!-- END SET $1 -->/d" /var/www/html/map/map-eu.html
    sed -i "/<!-- START SET $1 -->/,/<!-- END SET $1 -->/d" /var/www/html/map/map-us.html
  
    # Ouput IP address removed as crontab entry.
    echo "<< IP address $1 removed from schedule >>"
  
  fi

fi

exit 0
