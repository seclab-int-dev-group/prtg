###############################################################################################################

DESCRIPTION:  Automated system for pulling geolocation data from multiple IP addresses.

###############################################################################################################

DIRECTORY:    /home/e3admin/scripts/e3systems/

STRUCTURE:                               |---->e3systems.sh
                                         |---->scripts
                                         |       |---->db_add.sh
                                         |       |---->db_del.sh
                                         |       |---->ip_add.sh
                                         |       |---->ip_del.sh
                                         |       |---->ip_tel.sh
                                         |       |---->ip_ping.sh
                                         |       |---->sensors
                                         |                  |---->simple
                                         |                  |---->advanced
                                         |                              |---->latlong.sh
                                         |                              |---->rxsnr.sh
                                         |                              |---->beam.sh
                                         |                              |---->ping.sh
                                         |---->logs--->raw
                                         |       |       |---->ip.log
                                         |       |
                                         |       |---->output
                                         |       |       |---->ip.log
                                         |       |
                                         |       |----->ping
                                         |               |---->ip.log
                                         |                
                                         |----->documentation
                                                         |---->images
                                                         |---->documentation.html
                                                         |---->documentation.pdf
                                                        
###############################################################################################################

USAGE:        e3systems.sh - Main script. Calls iptel.sh automatically.
              db_add.sh    - Automatically reacreates database incase of corruption or deletion.
              db_del.sh    - Clears all data from database.
              ip_add.sh    - Adds new ip address to crontab schedule.
              ip_del.sh    - Removes an ip address from crontab schedule.
              ip_tel.sh    - Can be used to test ip address.
              ip_ping.sh   - Grabs ping and packet loss data.
              latlong.sh   - Automatically executed by PRTG Network Monitor.
              rxsnr.sh     - Automatically executed by PRTG Network Monitor.
              beam.sh      - Automatically executed by PRTG Network Monitor.
 
###############################################################################################################

COMMANDS:     e3systems.sh - "e3systems ip username password".
              db_add.sh    - "db_add".
              db_del.sh    - "db_del".
              ip_add.sh    - "ip_add ip username password".
              ip_del.sh    - "ip_del ip".
              ip_tel.sh    - "ip_tel ip username password".
              ip_ping.sh   - "ip_ping ip".
              latlong.sh   - "latlong ip".
              rxsnr.sh     - "rxnsr ip".
              beam.sh      - "beam ip".

###############################################################################################################

DOCUMENTATION: Detailed documentation can be found inside the /e3systems/documentation folder.

###############################################################################################################

CREATED BY:   William Thomas Bland.

###############################################################################################################
