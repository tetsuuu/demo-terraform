#!/bin/bash -v
yum update -y

yum -y remove ntp
yum -y install chrony
chkconfig chronyd on
/etc/init.d/chronyd start

# configure logrotate
# enabling log compress (logrotate.conf)
sed -i -e 's/#compress/compress/' /etc/logrotate.conf

# hostname change
sed -i -e "s%HOSTNAME=.*%HOSTNAME=${INSTANCE_NAME}%" /etc/sysconfig/network

# reboot for updating hostname
shutdown -r now
