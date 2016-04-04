mkdir /var/lib/influxdb
#chown influxdb. /var/lib/influxdb
mkdir /var/log/influxdb
#chown influxdb. /var/log/influxdb
dpkg -i influxdb_0.9.6_armhf.deb
chown influxdb. /var/lib/influxdb
chown influxdb. /var/log/influxdb
#./set_influx.sh
