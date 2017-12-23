#!/bin/bash

apt-get -y install ufw
apt-get -y install sudo
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

apt-get -y install php5-fpm php5-cli
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
/etc/init.d/nginx restart
/etc/init.d/php5-fpm restart

vnstat -u -i eth0
sudo chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

cd /home/vps/public_html/
wget https://github.com/nwqionnwkn/OPENEXTRA/raw/master/Config/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'th';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/IPv6/d' config.php

cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/php5-fpm restart
service openvpn restart
service cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
service vnstat restart
service squid3 restart
rm -rf ~/.bash_history && history -c
