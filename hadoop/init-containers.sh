#!/bin/bash

echo "stopping all containers containing string 'hadoop'"
sudo docker stop $(sudo docker ps -a -f "name=hadoop" | tail -n +2 | awk '{print $NF}')

echo "restarting hadoop network"
sudo docker network rm hadoop &> /dev/null
sudo docker network create --driver=bridge hadoop

# grabs from config the number of nodes to create
N=$((1 + `wc -l config/slaves | cut -d' ' -f1`)) 

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
echo "mounting volume /home/saint/data/volumes/medicare_data to /big/medicare-demo/ref_data"
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                -v /home/saint/data/volumes/medicare_data:/big/medicare-demo/ref_data \
                saintjames95/hadoop:base-master-config

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
