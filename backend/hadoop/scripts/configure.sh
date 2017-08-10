#!/bin/bash

#This script modifies the configuration file in this directory and copies it to the slave and master directories

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Missing Arguments"
    exit 1
fi

CLUSTER=$1
SLAVES=$2

i=1
cd ../image-building/

sudo rm config/slaves
while [ $i -le $SLAVES ]
do
    #Nameing Slaves - Example hadoop1-slave3
    sudo echo "hadoop${CLUSTER}-slave${i}" >> config/slaves
    ((i++))
done  

# Changes For Hadoop Master 
TAB=$'\t'
sudo sed -i "/<value>/c\ ${TAB}<value>hdfs://hadoop${CLUSTER}-master:9000/</value>" config/core-site.xml
sudo sed -i "/<value>had/c\ ${TAB}<value>hadoop${CLUSTER}-master</value>" config/yarn-site.xml

sudo rm -rf slave/config
sudo rm -rf master/config

cp -r config slave
cp -r config master

cd ../scripts
