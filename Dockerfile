#
# Grafana + Statsd + telegraf Dockerfile
#

# Pull base image.
FROM resin/rpi-raspbian

RUN apt-get update
RUN apt-get install -y libfontconfig supervisor && apt-get install -f

ADD install_influxdb.sh /root/
ADD influxdb_0.9.6_armhf.deb /root/
ADD telegraf_0.3.0-beta2_armhf.deb /root/
ADD install_grafana.sh /root/
ADD grafana_2.6.0_armhf.deb /root/

RUN chmod +x /root/install_influxdb.sh && cd /root && /root/install_influxdb.sh
RUN dpkg -i /root/telegraf_0.3.0-beta2_armhf.deb
RUN chmod +x /root/install_grafana.sh && cd /root && /root/install_grafana.sh

ADD influx.conf.toml /root/
ADD telegraf.conf /root/
ADD defaults.ini.grafana /usr/share/grafana/conf/defaults.ini

ADD entry.sh /entry.sh
RUN chmod 755 /entry.sh

ADD etc-supervisord.conf /etc/supervisor/supervisord.conf
ADD supervisord-influx.conf /etc/supervisor/conf.d/
ADD supervisord-telegraf.conf /etc/supervisor/conf.d/
ADD supervisord-grafana.conf /etc/supervisor/conf.d/

#influxdb admin web
EXPOSE 8083/tcp
#statsd udp
EXPOSE 8125/udp
#statsd tcp
EXPOSE 8126/tcp
#grafana web
EXPOSE 3000/tcp

VOLUME ['/var/lib/influxdb', '/var/log/influxdb', '/opt/grafana']

ENTRYPOINT ["/entry.sh"]
#influx -execute 'CREATE DATABASE "telegraf"'
#cd /usr/share/grafana && /usr/sbin/grafana-server
