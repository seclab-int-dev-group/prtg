#CentOS 7 Server Documentation

###Description
The CentOS 7 server serves as a proxy data gathering server for PRTG Network Monitor connecting to each IP address added as a cronjob via telnet, gathering location, Signal and Beam data every 5 minutes as well as gathering ping and packet loss data every 30 seconds. Data pulled from each IP address is stored in a MYSQL database on the CentOS 7 server. Custom PRTG SSH sensors are used to pull the gathered data for each IP address from the MYSQL database and update the values, messages and control room map for each sensor on PRTG Network Monitor.

---
<br>
###Project Files Location

Project files are located inside ***/home/e3admin/e3systems/***
![image00.jpg](images/image00.jpg)
![image01.jpg](images/image01.jpg)

---
<br>
###Adding an IP Address

Add a new IP address by running the following custom command: ***ip_add ipaddress username password***
![image02.jpg](images/image02.jpg)

---
<br>
###Removing an IP Address

Remove an IP address by running the following custom command: ***ip_del ipaddress***
![image03.jpg](images/image03.jpg)

---
<br>
#PRTG Network Monitor Documentation

###Adding a Device

***Step 1*** - Enter a desired name for device under “Device Name”.<br>
***Step 2*** - Select “Connect using IPv4” under “IP Version”.<br>
***Step 3*** - Under “IP Address/DNS Name”, enter the linux server’s IP address.<br>
***Step 4*** - Set “Sensor Management” to “Manual (no discovery)”.<br>
***Step 5*** - Make sure “Credentials for Linux/Solaris/Mac OS (SSH/WBEM) Systems” is selected.<br>
***Step 6*** - Click “Continue” to go to add the new device.<br>

![image04.jpg](images/image04.jpg)

---
<br>
###Adding a Custom Sensor

***Step 1*** - Under “Monitor What?” select “Custom Sensors”.<br>
***Step 2*** - Under “Target System Type” select “Linux/MacOS”.<br>
***Step 3*** - Select “SSH Script Advanced” and click “Add This”.<br>
***Step 4*** - Enter desired sensor name under “Sensor Name”.<br>
***Step 5*** - Select relevant script from drop down list under “Script”.<br>
***Step 6*** - Enter the IP address that will be monitored under “Parameters”.<br>
***Step 7*** - Click “Continue” to go to add the new custom sensor.<br>

![image05.jpg](images/image05.jpg)
![image06.jpg](images/image06.jpg)

---
<br>
###Adding a Custom Map Object

***Step 1*** - Select the sensor created from the previous steps from the “Device Tree” on the  left side.<br>
***Step 2*** - Select the “Status Icons” list from the “Properties” section on the right side.<br>
***Step 3*** - Find the desired custom map object “custom_message_e3systems” and drag to the map.<br>

![image07.jpg](images/image07.jpg)

---
