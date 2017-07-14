#!/bin/bash

# WARNING: Stop all containers and restart the network
sudo docker stop $(sudo docker ps -a -q)
sudo docker network rm hadoop
sudo docker network create --driver=bridge hadoop

# grabs from config the number of nodes to create
N=$((1 + `wc -l base-config/config/slaves | cut -d' ' -f1`)) 

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                saintjames95/hadoop:base-config-master


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                saintjames95/hadoop:base-config
	i=$(( $i + 1 ))
done 
