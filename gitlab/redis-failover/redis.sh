#!/bin/sh
#
# Script to start Redis and promote to MASTER/SLAVE
#
# Copyright (c) 2011 Alex Williams. See LICENSE for details.
#
# v0.3
#
# Usage Options:
#   -m    promote the redis-server to MASTER
#   -s    promote the redis-server to SLAVE
#   -k    start the redis-server and promote it to MASTER
#
# Tested:
#
#   - Redis 2.2.12
#   - Keepalived 1.1.20
#
# Redis Setup:
#
#   useradd -m -U redis
#   chmod 750 /home/redis
#   cd /home/redis
#   sudo -u redis git clone https://github.com/antirez/redis.git redis.git
#   cd redis.git
#   git checkout 2.2.12
#   sudo make
#
# Configurations:
#
#   MASTER/SLAVE config: /home/redis/redis-mdb.conf (runs on port 6379)
#
# How it works:
#
#   - Keepalived runs on the Redis MASTER and SLAVE servers
#   - The Redis MASTER binds the IP 172.16.0.180
#   - The Redis SLAVE connects to a Master server which has the IP 172.16.0.180
#   - Keepalived handles checking and runs a script if a server is online or offline
#   - This script will handle starting Redis promoting it to MASTER or SLAVE
#
# Note:
#
#   *This has NOT been tested in a production environment, use at your own risk*

#########################
# User Defined Variables
#########################

REDIS_COMMANDS="redis-cli"      # The location of the redis binary
REDIS_MASTER_IP="172.28.48.4"   # Redis MASTER ip
REDIS_MASTER_PORT="6379"        # Redis MASTER port
REDIS_CURRENT_STATE="SLAVE"
##############
# Exit Codes
##############

E_INVALID_ARGS=65
E_INVALID_COMMAND=66
E_NO_SLAVES=67
E_DB_PROBLEM=68

##########################
# Script Functions
##########################

## exit end echo error code if a error created
error() {
        E_CODE=$?
        echo "Exiting: ERROR ${E_CODE}: $E_MSG"

        exit $E_CODE
}

### change state slave to master 
start_master() {
        ${REDIS_COMMANDS} SLAVEOF no one
}

### change state master to salve
start_slave() {
        ${REDIS_COMMANDS} SLAVEOF ${REDIS_MASTER_IP} ${REDIS_MASTER_PORT}
}

### check and change state of current redis if master failure of up again
check_master() {
        alive=`${REDIS_COMMANDS} -h ${REDIS_MASTER_IP} -p ${REDIS_MASTER_PORT} PING`
        echo "PING MASTER IN $alive"
        if [ "$alive" != "PONG" ] && [ "${REDIS_CURRENT_STATE}" == "SLAVE" ]; then
                echo -e "MASTER NODE IS DOWN, PROMOTE TO MASTER"
                start_master
                REDIS_CURRENT_STATE="MASTER"
                sleep 1
        elif [ "$alive" == "PONG" ] && [ "${REDIS_CURRENT_STATE}" == "MASTER" ]; then
                echo -e "MASTER NODE IS UP AGAIN, DOWN STATE TO SLAVE"
                start_slave
                REDIS_CURRENT_STATE="SLAVE"
                sleep 1
        fi
}

### check master each 10s forever 
main () {
        while true
        do
                check_master
                sleep 10
        done
}

## start
main
