#!/bin/bash

###############################################################################################################################
#DESCRIPTION: A custom advanced ssh sensor for the PRTG Network Monitor.
#USAGE: Edit the variables with your configuration. Script is automatically called by PRTG.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

# Declare variables.
db="e3db"           # MySQL database name.
table="e3tb"        # MySQL table name.
dbuser="e3admin"    # MySQL database username
dbpass="E3System5!" # MySQL database password
rxsnr=$(mysql $db -u$dbuser -p$dbpass -e \
"SELECT Rx_SNR FROM $table WHERE IP_Address='$1';" | grep -v 'Rx_SNR' | awk '{printf "%.1f\n", $1}')
rxrr=$(mysql $db -u$dbuser -p$dbpass -e \
"SELECT Rx_raw_reg FROM $table WHERE IP_Address='$1';" | grep -v 'Rx_raw_reg')
rxrrl=$(mysql $db -u$dbuser -p$dbpass -e \
"SELECT Rx_raw_reg_lookup FROM $table WHERE IP_Address='$1';" | grep -v 'Rx_raw_reg_lookup')
msg="Rx SNR $rxsnr dB"

###############################################################################################################################

# convert RX SNR, RX Raw Reg and RX Raw Reg Lookup data to PRTG compatible xml format.
echo -n "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<prtg>
  <result>
    <channel>RX SNR</channel>
    <float>1</float>
    <value>$rxsnr</value>
    <unit>Custom</unit>
    <customunit>dB</customunit>
  </result>
  <result>
    <channel>RX Raw Reg</channel>
    <float>1</float>
    <value>$rxrr</value>
    <unit>Custom</unit>
    <customunit>dB</customunit>
  </result>
  <result>
    <channel>RX Raw Reg Lookup</channel>
    <float>1</float>
    <value>$rxrrl</value>
    <unit>Custom</unit>
    <customunit>dB</customunit>
  </result>
  <text>$msg</text>
</prtg>"

exit 0
