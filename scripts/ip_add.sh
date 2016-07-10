#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for adding an IP address to crontab.
# USAGE:            Run script with IP address, username and password set as arguments and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables.
user="e3admin"      # User that script will be executed under.
db="e3db"           # MySQL database name.
table="e3tb"        # MySQL table name.
dbuser="e3admin"    # MySQL database username
dbpass="E3System5!" # MySQL database password
cron=$(mysql $db -u$dbuser -p$dbpass -e "SELECT IP_Address FROM $table WHERE IP_Address='$1';" | grep -v 'IP_Address')

###############################################################################################################################

# Check if options are populated.
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then

  # Output error if options are not populated.
  echo "<< Invalid entry >> Correct usage: ipadd [ipaddress] [username] [password]"

else
  
  # Check if IP address is already populated in schedule.
  if  [ "$cron" == "$1" ]; then
    
    # Output warning if IP address is found in current schedule.
    echo " << IP address $1 was already previously set in current schedule >> "
  
  else
	    
    # Insert IP address into new row in mysql databse.
    mysql $db -u$dbuser -p$dbpass -e "INSERT INTO \
    $table (IP_Address) \
    VALUES ('$1');"

    # Run main script once to test connection, credentials and populate database.
    /home/$user/e3systems/e3systems.sh $1 $2 $3 $4
    
    # Run ping script once to test populate database with ping and packet loss data.
    /home/$user/e3systems/scripts/ip_ping.sh $1

    # Add line to crontab to run e3systems.sh script every 5 minutes with IP address, username and password arguments.
    sudo sh -c "echo '*/5 * * * * $user \
    /home/$user/e3systems/e3systems.sh $1 $2 $3 $4' \
    >> /etc/crontab"
    
    # Add line to crontab to run ipping.sh script command every minute with IP address arguments.
    sudo sh -c "echo '* * * * * $user \
    /home/$user/e3systems/scripts/ip_ping.sh $1; \
    sleep 30; \
    /home/$user/e3systems/scripts/ip_ping.sh $1' \
    >> /etc/crontab"
  fi
fi

exit 0
