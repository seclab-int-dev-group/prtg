#!/usr/bin/expect

###############################################################################################################################
# DESCRIPTION:      Automated expect script for telnet connections of modems.
# USAGE:            This script is automatically executed by the parent script e3systems.sh
# CREATED BY:       William Thomas Bland.
###############################################################################################################################

# Declare variables and pass arguments.
set ip [lindex $argv 0]
set user [lindex $argv 1]
set pass [lindex $argv 2]

###############################################################################################################################

# Open telnet session to modem.
spawn /usr/bin/telnet $ip

# Enter username of modem.
expect "Username"
send $user\r

# Enter password of modem.
expect "Password"
send $pass\r

# Run latlong command.
expect "^>"
send "latlong\r"

# Run rx snr command.
expect "*W$"
send "rx snr\r"

# Run beamselector list command.
expect "*lookup*"
send "beamselector list\r"

# Close telnet session.
expect "*selected"
send "exit\r"

exit 0
