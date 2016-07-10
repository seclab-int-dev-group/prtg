#!/bin/bash

###############################################################################################################################
# DESCRIPTION:      Automated bash script for pulling geolocation data.
# USAGE:            Edit the variables with desired configuration and execute.
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables.
user="e3admin"
db="e3db"                        		   # MySQL database name.
table="e3tb"                     		   # MySQL table name.
dbuser="e3admin"                  		   # MySQL database username
dbpass="E3System5!"             	           # MySQL database password
outlog="/home/$user/e3systems/logs/output"         # Output log file location.
rawlog="/home/$user/e3systems/logs/raw"            # Raw log file location.
pinglog="/home/$user/e3systems/logs/ping"
telnet="/home/$user/e3systems/scripts/ip_tel.sh"   # Telnet script location.

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

        if [[ $lat == *N ]]; then
                lat=$(echo "$lat" | sed 's/.$//' | sed 's/ //')
        else
                lat=$(echo "-$lat" | sed 's/.$//' | sed 's/ //')
        fi

        # Convert Latitude variable to PRTG compatible value.
        if [[ $long == *E ]]; then
                long=$(echo "$long" | sed 's/.$//' | sed 's/ //')
        else
                long=$(echo "-$long" | sed 's/.$//' | sed 's/ //')
        fi

name=$(echo $4 | tr '[:upper:]' '[:lower:]' | sed -e 's/ //g')

# Insert data from above variables into MySQL database table.
mysql $db -u$dbuser -p$dbpass -e "UPDATE $table SET \
Name='$name', \
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

checkip=$(grep "($1)" /var/www/html/map/index.html | cut -d'(' -f2 | cut -d')' -f1)

content=$(echo $4 | tr '[:lower:]' '[:upper:]' | sed -e 's/_/ /g')

if [[ -z "$checkip" && "$lat" == *.* && "$long" == *.* ]]; then


sed -i "s/<!-- START MAP MARKERS -->/<!-- START MAP MARKERS -->\n<!-- START SET $1 -->\nvar $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-online.png',});\n$name\_marker.setMap(map);\nvar $name\_info = new google.maps.InfoWindow({content:\"$content\"});\ngoogle.maps.event.addListener($name\_marker, \'click\', function() {$name\_info.open(map,$name\_marker);});\n<!-- END SET $1 -->/g" /var/www/html/map/maps/global.html

sed -i "s/<!-- START MAP MARKERS -->/<!-- START MAP MARKERS -->\n<!-- START SET $1 -->\nvar $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-online.png',});\n$name\_marker.setMap(map);\nvar $name\_info = new google.maps.InfoWindow({content:\"$content\"});\ngoogle.maps.event.addListener($name\_marker, \'click\', function() {$name\_info.open(map,$name\_marker);});\n<!-- END SET $1 -->/g" /var/www/html/map/maps/mediterranean.html

sed -i "s/<!-- START MAP MARKERS -->/<!-- START MAP MARKERS -->\n<!-- START SET $1 -->\nvar $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-online.png',});\n$name\_marker.setMap(map);\nvar $name\_info = new google.maps.InfoWindow({content:\"$content\"});\ngoogle.maps.event.addListener($name\_marker, \'click\', function() {$name\_info.open(map,$name\_marker);});\n<!-- END SET $1 -->/g" /var/www/html/map/maps/caribbean.html

sed -i "s/<!-- START MAP MARKERS -->/<!-- START MAP MARKERS -->\n<!-- START SET $1 -->\n<li><a href=\"\#\"><img src=\"images\/marker-online.png\"> $content ($1)<\/a><\/li>\n<!-- END SET $1 -->/g" /var/www/html/map/index.html

else

if [[ -z "$checkip" || "$lat" != *.* || "$long" != *.* ]]; then

	echo "Could not complete $1 connection. Skipping marker update."

else

#name=$(echo $name | sed 's/_/\\_/')
if [[ -n "$checkip" && "$lat" == *.* && "$long" == *.* ]]; then
sed -i "s/^var $name\_.*.png',});$/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-online.png',});/" /var/www/html/map/maps/global.html
sed -i "s/^var $name\_.*.png',});$/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-online.png',});/" /var/www/html/map/maps/mediterranean.html
sed -i "s/^var $name\_.*.png',});$/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-online.png',});/" /var/www/html/map/maps/caribbean.html
sed -i "s/^<li><a href=\"\#\"><img src=\"images\/marker-.*.png\"> $content ($1)<\/a><\/li>$/<li><a href=\"\#\"><img src=\"images\/marker-online.png\"> $content ($1)<\/a><\/li>/" /var/www/html/map/index.html

#getping=$(mysql e3db -ue3admin -pE3System5! -e "SELECT Ping FROM e3tb WHERE IP_Address='$1';" | grep -v 'Ping')

getping=$(grep 'time=' $pinglog/"$1" | cut -d'=' -f4 | sed 's/ ms//g')


echo "$1" > /home/e3admin/e3systems/test.txt
echo "$getping" >> /home/e3admin/e3systems/test.txt

if [[ -n "$checkip" && "$getping" -gt 900 ]]; then
sed -i "s/^var $name\_.*.png',});$/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-warning.png',});/" /var/www/html/map/maps/global.html
sed -i "s/^var $name\_.*.png',});$/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-warning.png',});/" /var/www/html/map/maps/mediterranean.html
sed -i "s/^var $name\_.*.png',});$/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng($lat,$long),icon:'..\/images\/marker-warning.png',});/" /var/www/html/map/maps/caribbean.html
sed -i "s/^<li><a href=\"\#\"><img src=\"images\/marker-.*.png\"> $content ($1)<\/a><\/li>$/<li><a href=\"\#\"><img src=\"images\/marker-warning.png\"> $content ($1)<\/a><\/li>/" /var/www/html/map/index.html
fi




fi


fi

fi

if [[ -n "$checkip" ]]; then

	if [[ -z "$getping" || "$lat" != *.* || "$long" != *.* ]]; then

sed -i "^var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng(\(.*\)),icon:'..\/images\/marker-*.png',});/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng(\1),icon:'..\/images\/marker-offline.png',});/" /var/www/html/map/maps/global.html
sed -i "^var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng(\(.*\)),icon:'..\/images\/marker-*.png',});/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng(\1),icon:'..\/images\/marker-offline.png',});/" /var/www/html/map/maps/mediterranean.html
sed -i "^var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng(\(.*\)),icon:'..\/images\/marker-*.png',});/var $name\_marker=new google.maps.Marker({position:new google.maps.LatLng(\1),icon:'..\/images\/marker-offline.png',});/" /var/www/html/map/maps/caribbean.html
sed -i "s/^<li><a href=\"\#\"><img src=\"images\/marker-.*.png\"> $content ($1)<\/a><\/li>$/<li><a href=\"\#\"><img src=\"images\/marker-offline.png\"> $content ($1)<\/a><\/li>/" /var/www/html/map/index.html

grep "var $name\_.*.png',});$/var $name\_marker"

	fi
fi

exit 0
