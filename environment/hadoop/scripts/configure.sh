#!/bin/bash
#This script modifies the configuration file in this directory and copies it to the slave and master directories
#It allows one to specify the cluster ID number and the number of slaves for the cluster
#Configures the cluster to expect hostnames of the form hadoop<clusterID>-slave<slaveNum> where slaveNum starts at 1 and increments
#USAGE: $1 = Cluster ID Num, $2 = Number of Slaves

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Missing Arguments"
    exit 1
fi

THIS_DIR=$PWD
CLUSTER=$1
SLAVES=$2

#Copies configuration files to the Dockerfile parent directory
cp -r $HOME/Use-Case-Healthcare/environment/hadoop/config  $HOME/Use-Case-Healthcare/environment/hadoop/dockerfiles

#To hadoop environment dockerfiles
cd $HOME/Use-Case-Healthcare/environment/hadoop/dockerfiles

#Remove existing slave configuration
rm config/slaves

i=1
while [ $i -le $SLAVES ]
do
    #Nameing Slaves - Example hadoop1-slave3
    echo "hadoop${CLUSTER}-slave${i}" >> config/slaves
    ((i++))
done

# Changes For Hadoop Master Based on Cluster ID
TAB=$'\t'
sed -i "/<value>/c\ ${TAB}<value>hdfs://hadoop${CLUSTER}-master:9000/</value>" config/core-site.xml
sed -i "/<value>had/c\ ${TAB}<value>hadoop${CLUSTER}-master</value>" config/yarn-site.xml

#Replace existing configuration
rm -rf slave/config
rm -rf master/config
cp -r config slave
cp -r config master

#Remove from dockerfiles parent directory
rm -rf config
cd $THIS_DIR

