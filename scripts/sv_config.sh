#!/bin/bash

yum -y update

yum install -y ntp httpd

systemctl enable ntpd
systemctl start ntpd

semanage fcontext --add -t httpd_sys_rw_content_t 'var/www/html(/.*)?'
restorecon -R -v /var/www/html
rm -f /etc/httpd/conf.d/welcome.conf
systemctl enable httpd
systemctl start httpd

exit 0
