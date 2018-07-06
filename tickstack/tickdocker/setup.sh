docker network create tsdb-test
docker run -d -it --name influxdb -p 8086:8086 --network tsdb-test influxdb
docker run -it -d --network tsdb-test \
    --name telegraf --hostname quydx-tick \
    -v /sys:/rootfs/sys:ro \
    -v /proc:/rootfs/proc:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /var/run/utmp:/var/run/utmp:ro \
    -v /root/tickdocker/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
    telegraf
docker run -it -p 8888:8888 -d --name chronograf --network tsdb-test chronograf
docker run -d --network tsdb-test \
    -p 9092:9092 --hostname kapacitor \
    -e KAPACITOR_INFLUXDB_0_URLS_0=http://influxdb:8086 \
    --name kapacitor \
    kapacitor

docker exec -it kapacitor cat /tmp/alerts.log