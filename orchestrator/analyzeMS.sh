#!/bin/bash

# USAGE: $1 = Cluster ID Number, $2 = Number of Slaves, $3 = Percentage of data recieved from preprocessing to run analytics on, $4 = Directory on host containing the preprocessing data, $5 = Output File on Host, $6 = Overwritten Runtime Command 
# DESCRIPTION: Initialize Hadoop Cluster and Network for Analytics

if [ -z "$1" ]
  then
    echo "No Cluster Number Supplied"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "Number of Slaves not Supplied"
    exit 1
fi

CLUSTER=hadoop${1}
NUM_SLAVES=$2
PCT=$3
DATA_DIR=$4
OUTPUT_FILE=$5
CMD=$6

# Stop current instance of this cluster and network if exists
echo "Stopping and removing all containers containing string '${CLUSTER}' in container name..."
docker stop $(docker ps -a -f "name=${CLUSTER}" | tail -n +2 | awk '{print $NF}') &> /dev/null
docker rm $(docker ps -a -f "name=${CLUSTER}" | tail -n +2 | awk '{print $NF}') &> /dev/null

echo "Removing ${CLUSTER} network if it exists..."
docker network rm ${CLUSTER} &> /dev/null

# Create network, remove old net if exists
echo "Creating ${CLUSTER} network..."
docker network create --driver=bridge ${CLUSTER}

# Starting Hadoop Slaves 
i=1
while [ $i -le $NUM_SLAVES ]
do
        echo "Starting hadoop-slave$i container..."
        docker run -itd \
			--privileged=true \
                        --net=${CLUSTER} \
                        --name ${CLUSTER}-slave$i \
                        --hostname ${CLUSTER}-slave$i \
                        nbdif/healthcare:slave2
        i=$(( $i + 1 ))
done

# Starting Hadoop Master 
echo "Starting hadoop-master container..."
eval docker run -itd \
		--privileged=true \
                --net=${CLUSTER} \
                -p 5007${1}:50070 \
                -p 808${1}:8088 \
                --name ${CLUSTER}-master \
                --hostname ${CLUSTER}-master \
                -e \"PCT=$PCT\" \
                -v ${DATA_DIR}:/big/medicare-demo/ref_data \
      	        -v ${OUTPUT_FILE}:/big/medicare-demo/output.txt \
                nbdif/healthcare:app_analyze $CMD
