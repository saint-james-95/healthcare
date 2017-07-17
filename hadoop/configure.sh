#!/bin/bash

# N is the node number of hadoop cluster
N=$1

if [ $# = 0 ]
then
	echo "Please specify the node number of hadoop cluster!"
	exit 1
fi

# N nodes to config setup
i=1
sudo rm config/slaves
while [ $i -lt $N ]
do
    sudo echo "hadoop-slave$i" >> config/slaves
	((i++))
done  

sudo rm -rf base-config/config
sudo rm -rf base-master-config/config

sudo cp -r config base-config
sudo cp -r config base-master-config
