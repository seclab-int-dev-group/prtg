#!/bin/bash

###############################################################################################################################
#DESCRIPTION: A custom advanced ssh sensor for the PRTG Network Monitor.
#USAGE: Edit the variables with your configuration. Script is automatically called by PRTG.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

# Declare variables.
db=""         # MySQL database name.
table=""      # MySQL table name.
dbuser=""           # MySQL database username
dbpass=""           # MySQL database password
lat=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Latitude FROM $table WHERE IP_Address='$1';" | grep -v 'Latitude')
long=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Longitude FROM $table WHERE IP_Address='$1';" | grep -v 'Longitude')
msg="$lat, $long"

###############################################################################################################################

# Convert Longitude variable to PRTG compatible value.
if [[ $lat == *N ]]; then
  lat=$(echo "$lat" | sed 's/.$//')
else
  lat=$(echo "-$lat" | sed 's/.$//')
fi

# Convert Latitude variable to PRTG compatible value.
if [[ $long == *E ]]; then
  long=$(echo "$long" | sed 's/.$//')
else
  long=$(echo "-$long" | sed 's/.$//')
fi

# convert Latitude and Longitude data to PRTG compatible xml format.
echo -n "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<prtg>
  <result>
    <channel>Latitude</channel>
    <float>1</float>
    <value>$lat</value>
    <unit>Custom</unit>
    <customunit>deg</customunit>
  </result>
  <result>
    <channel>Longitude</channel>
    <float>1</float>
    <value>$long</value>
    <unit>Custom</unit>
    <customunit>deg</customunit>
  </result>
  <text>$msg</text>
</prtg>"

exit 0
