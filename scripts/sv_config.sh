#!/bin/bash

yum -y update

yum install -y wget ntp httpd mariadb-server zip unzip

systemctl enable ntpd
systemctl start ntpd

semanage fcontext --add -t httpd_sys_rw_content_t 'var/www/html/map(/.*)?'
restorecon -R -v /var/www/html/map
rm -f /etc/httpd/conf.d/welcome.conf
systemctl enable httpd
systemctl start httpd

systemctl enable mariadb
systemctl start mariadb

wget https://github.com/william-thomas-bland/e3systems/archive/master.zip

unzip master.zip /home/e3admin/

mv /home/e3admin/e3systems-master /home/e3admin/e3systems

rm -rf master.zip

chown -R e3admin:e3admin /home/e3admin/e3systems

chmod -R 700 /home/e3admin/e3systems

mkdir -p /var/www/html/map
cp /home/e3admin/maps/* /var/www/html/map/

mkdir -p /var/prtg/scriptsxml
cp /home/e3admin/senors/advanced/* /var/prtg/scriptsxml/

exit 0
