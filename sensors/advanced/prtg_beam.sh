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
beam=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Beam_Int FROM $table WHERE IP_Address='$1';" \
| grep -v 'Beam_Int')
msg=$(mysql $db -u$dbuser -p$dbpass -e "SELECT Beam_Str FROM $table WHERE IP_Address='$1';" \
| grep -v 'Beam_Str' | sed 's/(Not in map)//')

###############################################################################################################################

# convert Beam data to PRTG compatible xml format.
echo -n "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<prtg>
  <result>
    <channel>Beam</channel>
    <float>1</float>
    <value>$beam</value>
    <unit>Custom</unit>
    <customunit>Beam</customunit>
  </result>
  <text>$msg</text>
</prtg>"

exit 0
