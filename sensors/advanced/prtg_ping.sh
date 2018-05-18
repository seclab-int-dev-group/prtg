!/bin/bash

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
ping=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Ping FROM $table WHERE IP_Address='$1';" | grep -v 'Ping')
pktloss=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Packet_loss FROM $table WHERE IP_Address='$1';" | grep -v 'Packet_loss')
msg="Ping: $ping msec, Packet Loss: $pktloss %"

###############################################################################################################################

# convert ping data to PRTG compatible xml format.
echo -n "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<prtg>
  <result>
    <channel>Ping</channel>
    <float>1</float>
    <value>$ping</value>
    <unit>Custom</unit>
    <customunit>msec</customunit>
  </result>
    <result>
    <channel>Packet Loss</channel>
    <float>1</float>
    <value>$pktloss</value>
    <unit>Custom</unit>
    <customunit>%</customunit>
  </result>
  <text>$msg</text>
</prtg>"

exit 0
