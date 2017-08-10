BACKEND_DIR=/home/sheehan/Github/healthcare/backend
APP_DIR=/home/sheehan/Github/healthcare/apps
DATA_DIR=/home/sheehan/Github/healthcare/data
THIS_DIR=$PWD
HOST_VOLUME="${PWD}/data-volume"

#Usable Backends
UBUNTU_BACK="backend/backend:ubuntu"
HADOOP_BACK="backend/backend:master"

#Supplimentary Backends 
HADOOP_BACK_SLAVE="saintjames95/hadoop:base"
HADOOP_BACK_MASTER="saintjames95/hadoop:base-master"

#Backend Config
NUM_SLAVES="3"
CLUSTER_NUMBER="1"

#Backend builder
sudo docker build -t $UBUNTU_BACK ${BACKEND_DIR}/ubuntu
sudo docker build -t $HADOOP_BACK_MASTER ${BACKEND_DIR}/hadoop/image-building/base  
sudo docker build -t $HADOOP_BACK_MASTER ${BACKEND_DIR}/hadoop/image-building/base-master  

cd ${BACKEND_DIR}/hadoop/scripts/
./configure.sh $CLUSTER_NUMBER $NUM_SLAVES
./build-images.sh $CLUSTER_NUMBER $NUM_SLAVES #outputs backend/backend:master and the slave
cd $THIS_DIR

#COLLECTION MICRO SERVICE

COLLECT_VOLUME=${HOST_VOLUME}/Data  					# Volume on Host to Mount 
COLLECT_IO="/root/output"						# Data Output Directory on Container. 
COLLECT_BACK=$UBUNTU_BACK						# Backend To Use (2 available: Hadoop and Ubuntu)
COLLECT_IMAGE="app/app:collect"						# Application Image Name
COLLECT_COMMAND="\"-c\", \"cd ${COLLECT_IO} && /root/collect.sh\""	# Application Run Command
COLLECT_DIR="${APP_DIR}/collectionApp"					# Directory on Host Where Application Exists

#Make Application
#This attaches the application files to the correct environment
#USAGE: Backend Image -- Application Files -- Command -- Application Image Tag

./make-app.sh $COLLECT_BACK $COLLECT_DIR "${COLLECT_COMMAND}" $COLLECT_IMAGE /root

#Run Application
#sudo docker run -v ${COLLECT_VOLUME}:${COLLECT_IO} -itd $COLLECT_IMAGE

#RUN1 MICROSERVICE

RUN1_VOLUME=${HOST_VOLUME}/Data                           
RUN1_IO="/big/medicare-demo/ref_data"                      
RUN1_BACK=$HADOOP_BACK                               
RUN1_IMAGE="app/app:run1"                                    
RUN1_COMMAND="\"-c\", \"service ssh start && sleep 10 && /root/start-hadoop.sh && cd /big/medicare-demo && /big/medicare-demo/run1.sh\""   
RUN1_DIR="${APP_DIR}/preprocessApp"                           

#USAGE: Backend Image -- Application Files -- Command -- Application Image Tag
./make-app.sh $RUN1_BACK $RUN1_DIR "${RUN1_COMMAND}" $RUN1_IMAGE /big/medicare-demo

#Run Application
./init-containers.sh 1 3 $RUN1_IMAGE













