#!/bin/bash

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

# Stop current instance of this cluster if exists
echo "stopping and removing all containers containing string '${CLUSTER}'"
sudo docker stop $(sudo docker ps -a -f "name=${CLUSTER}" | tail -n +2 | awk '{print $NF}')
sudo docker rm $(sudo docker ps -a -f "name=${CLUSTER}" | tail -n +2 | awk '{print $NF}')

# Restart Network if exists
echo "restarting ${CLUSTER} network"
sudo docker network rm ${CLUSTER}
sudo docker network create --driver=bridge ${CLUSTER}

# start hadoop master container
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=${CLUSTER} \
                -p 5007${1}:50070 \
                -p 808${1}:8088 \
                --name ${CLUSTER}-master \
                --hostname ${CLUSTER}-master \
		 -v ${HOME}/Use-Case-Healthcare/data:/big/medicare-demo/ref_data/ \
                environment:master &> /dev/null


# start hadoop slave container
i=1
while [ $i -le $2 ]
do
        echo "start hadoop-slave$i container..."
        sudo docker run -itd \
                        --net=${CLUSTER} \
                        --name ${CLUSTER}-slave$i \
                        --hostname ${CLUSTER}-slave$i \
                        environment:slave &> /dev/null
        i=$(( $i + 1 ))
done
