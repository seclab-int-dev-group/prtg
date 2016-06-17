#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for adding an IP address to crontab.
# USAGE:            Run script with IP address, username and password set as arguments and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables.
user="e3admin"          					# User that script will be executed under.
db="e3db"           						# MySQL database name.
table="e3tb"        						# MySQL table name.
dbuser="e3admin"           					# MySQL database username.
dbpass="E3System5!"           					# MySQL database password.
vessel=$(echo $4 | tr '[:upper:]' '[:lower:]' \			# Vessel name.
 | sed -e 's/ /_/g')
cron=$(mysql $db -u$dbuser -p$dbpass -e \			# Cronjob IP address.
"SELECT IP_Address FROM $table WHERE IP_Address='$1';" \
 | grep -v 'IP_Address')
check=0

###############################################################################################################################


if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

 for i in {1..4}; do
 
  ip=$(echo $1 | cut -d'.' -f$i)
 
  if [ $ip -le 254 ] && [ -n $ip]; then

   check=$(( $check + 1 ))
   
  fi
 
 done

# Check if options are populated.
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -n "$5" ]; then

  # Output error if options are not populated.
  echo "<< Invalid entry >> Correct usage: ipadd [ipaddress] [username] [password] [vessel]"

else
  
  # Check if IP address is already populated in schedule.
  if  [ "$cron" == "$1" ]; then
    
    # Output warning if IP address is found in current schedule.
    echo "<< IP address $1 has already been added to the current schedule >>"
  
  else
	    
    # Insert IP address into new row in mysql databse.
    mysql $db -u$dbuser -p$dbpass -e "INSERT INTO \
    $table (IP_Address) \
    VALUES ('$1');"
    
    # Insert vessel name into new row in mysql databse.
    mysql $db -u$dbuser -p$dbpass -e "INSERT INTO \
    $table (Vessel) \
    VALUES ('$vessel') \
    WHERE IP_Address="$1";"

    # Run main script once to test connection, credentials and populate database.
    /home/$user/e3systems/e3systems.sh "$1" "$2" "$3" "$vessel"
    
    # Run ping script once to test populate database with ping and packet loss data.
    /home/$user/e3systems/scripts/ip_ping.sh "$1"

    lat=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Latitude FROM $table WHERE IP_Address='$1';" \
    | grep -v 'Latitude')

    if [ -z "$lat" ]; then
    
    	# Output warning if telnet script did not populate mysql database fields.
    	echo " << IP address $1 did not succesfully complete the telnet connection test >> "
    	
	# Clear IP address from database.   
    	mysql $db -u$dbuser -p$dbpass -e "DELETE FROM $table WHERE IP_Address='$1';"
	
    else
    
    	# Add line to crontab to run e3systems.sh script every 5 minutes with IP address, username and password arguments.
    	sudo sh -c "echo '*/5 * * * * $user \
    	/home/$user/e3systems/e3systems.sh $1 $2 $3 $vessel' \
    	>> /etc/crontab"
    
	# Add line to crontab to run ipping.sh script command every minute with IP address arguments.
    	sudo sh -c "echo '* * * * * $user \
    	/home/$user/e3systems/scripts/ip_ping.sh $1; \
    	sleep 30; \
    	/home/$user/e3systems/scripts/ip_ping.sh $1' \
    	>> /etc/crontab"

    	# Ouput IP address added as crontab entry.
    	echo "<< IP address $1 added to schedule >>"
    	
    fi
  fi
fi

else

 echo "<< $1 is not a valid IP address >>"

fi

exit 0
