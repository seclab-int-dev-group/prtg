#Linux Documentation

###Description
The linux machine serves as a proxy data gathering server for PRTG connecting to each IP address added as a cronjob via telnet, gathering location, Signal and Beam every 5 minutes as well as gathering ping and packet loss data every 30 seconds. Data pulled from each IP address is stored in a MYSQL database (e3db) table (e3tb). Custom PRTG sensors are used to pull the gathered data from the MYSQL database and update the values and messages for each sensor.

Project files are located inside /home/e3admin/e3systems/
![linux01.jpg](images/image02.jpg)
![linux02.jpg](images/image06.jpg)

Add a new IP address by running the following custom command:
*ip_add ipaddress username password*
![linux03.jpg](images/image03.jpg)

Remove an IP address by running the following custom command:
*ip_del ipaddress*
![linux04.jpg](images/image00.jpg)



<span class="c10"><< PRTG Documentation >></span>

<span class="c2"></span>

<span class="c2"></span>

<span class="c9">-- Adding a Device --</span>

<span class="c9"></span>

<span class="c12 c4">1</span><span class="c4"> - Enter a desired name for device under “Device Name”.</span>

<span class="c12 c4">2</span><span class="c4"> - Select “Connect using IPv4” under “IP Version”.</span>

<span class="c12 c4">3</span> <span class="c4">- Under “IP Address/DNS Name”, enter the linux server’s IP address.</span>

<span class="c12 c4">4</span><span class="c4"> - Set “Sensor Management” to “Manual (no discovery)”.</span>

<span class="c4 c12">5</span><span class="c4"> - Make sure “Credentials for Linux/Solaris/Mac OS (SSH/WBEM) Systems” is selected.</span>

<span class="c12 c4">6</span><span class="c4"> - Click “Continue” to go to add the new device.</span>

<span class="c15"></span>

<span class="c9">-- Adding a Custom Sensor --</span>

<span class="c4"></span>

<span class="c12 c4">1</span><span class="c4"> - Under “Monitor What?” select “Custom Sensors”.</span>

<span class="c12 c4">2</span><span class="c4"> - Under “Target System Type” select “Linux/MacOS”.</span>

<span class="c12 c4">3</span><span class="c4"> - Select “SSH Script Advanced” and click “Add This”.</span>

<span class="c12 c4">4</span><span class="c4"> - Enter desired sensor name under “Sensor Name”.</span>

<span class="c12 c4">5</span><span class="c4"> - Select relevant script from drop down list under “Script”.</span>

<span class="c12 c4">6</span><span class="c4"> - Enter the IP address that will be monitored under “Parameters”.</span>

<span class="c12 c4">7</span><span class="c4"> - Click “Continue” to go to add the new custom sensor.</span>

<span class="c15"></span>

<span class="c9">-- Adding a Custom Map Object --</span>

<span class="c4"></span>

<span class="c12 c4">1</span><span class="c4"> - Select the sensor created from the previous steps from the “Device Tree” on the  left side.</span>

<span class="c12 c4">2</span><span class="c4"> - Select the “Status Icons” list from the “Properties” section on the right side.</span>

<span class="c12 c4">3</span><span class="c4"> - Find the desired custom map object “custom_message_e3systems” and drag to the map.</span>

<span class="c4"></span>

<span class="c4"></span>

<span class="c4"></span>

<span class="c4"></span>

<span class="c4"></span>

<span class="c4">-- Instructional screenshots provided on next pages --</span>

<span class="c9"></span>

<span class="c9">--</span> <span class="c9">Adding a Device --</span>

<span class="c2"></span>

<span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 702.67px;">![device01.jpg](images/image07.jpg)</span>

<span class="c9"></span>

<span class="c9"></span>

<span class="c9"></span>

<span class="c9">-- Adding a Custom Sensor --</span>

<span class="c2"></span>

<span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 537.33px;">![sensor01.jpg](images/image01.jpg)</span>

<span class="c2"></span>

<span class="c4"></span>

<span class="c15"></span>

<span class="c4"></span>

<span class="c4"></span>

<span class="c4">-- Adding a Custom Sensor</span><span class="c12 c4"> </span><span class="c4">continued on next page --</span>

<span class="c2"></span>

<span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 848.00px;">![sensor02.jpg](images/image04.jpg)</span>

<span class="c9">-- Adding a Custom Map Object --</span>

<span class="c2"></span>

<span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 624.00px; height: 716.00px;">![map01.jpg](images/image05.jpg)</span>

<span class="c2"></span>

<span class="c12 c4"></span>

<span class="c4">-- End of PRTG Documentation --</span>
