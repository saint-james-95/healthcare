#!/bin/bash
#This script modifies the configuration file in this directory and copies it to the slave and master directories

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Missing Arguments"
    exit 1
fi

CLUSTER=$1
SLAVES=$2

#Exit out of scripts, to hadoop dir
cd ../
cp -r config image-building
cd image-building

#In image-building dir
rm config/slaves

i=1
while [ $i -le $SLAVES ]
do
    #Nameing Slaves - Example hadoop1-slave3
    echo "hadoop${CLUSTER}-slave${i}" >> config/slaves
    ((i++))
done

# Changes For Hadoop Master 
TAB=$'\t'
sed -i "/<value>/c\ ${TAB}<value>hdfs://hadoop${CLUSTER}-master:9000/</value>" config/core-site.xml
sed -i "/<value>had/c\ ${TAB}<value>hadoop${CLUSTER}-master</value>" config/yarn-site.xml

#Replace existing configuration
rm -rf slave/config
rm -rf master/config
cp -r config slave
cp -r config master

#Remove from image building
rm -rf config
cd ../scripts

