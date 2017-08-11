#Internal Orchestrator Needs to Know From Host:
APP_DIR=/home/sheehan/Github/healthcare/apps
BACKEND_DIR=/home/sheehan/Github/healthcare/backend
DATA_DIR=/home/sheehan/Github/healthcare/data

#Other
THIS_DIR=$PWD
HOST_VOLUME="${PWD}/data-volume"

#Usable Backends - Need to Know Image Name - Backend (AKA Environment) + Application Files = Standalone application
UBUNTU_BACK="backend/backend:ubuntu"
HADOOP_BACK="backend/backend:master"
	#Supplimentary Backends For Hadoop 
	HADOOP_BACK_SLAVE="saintjames95/hadoop:base"
	HADOOP_BACK_MASTER="saintjames95/hadoop:base-master"

	#Supplimentary Backend Config - Could be specified by data scientist or internal orchestrator
	#NUM_SLAVES="3"
	#CLUSTER_NUMBER="1"

#Backend builder
#Build What the Data Scientist Asks For
#Data Scientist Says I want to collect data from internet, preprocess with Hadoop/Pig, post postprocess with Hadoop/Pig

#For Data Collection Need

	#Supplimentary - None
	
	#Application Builds On
	sudo docker build -t $UBUNTU_BACK ${BACKEND_DIR}/ubuntu

#For Pre and Post Process Need

	#Supplimentary
	
		#Slave
		sudo docker build -t $HADOOP_BACK_SLAVE ${BACKEND_DIR}/hadoop/image-building/base  

		#Master
		sudo docker build -t $HADOOP_BACK_MASTER ${BACKEND_DIR}/hadoop/image-building/base-master  

	#Application Builds On:	

		#outputs HADOOP_BACK 
		#cd ${BACKEND_DIR}/hadoop/scripts/
		#./configure.sh $CLUSTER_NUMBER $NUM_SLAVES
		#./build-images.sh $CLUSTER_NUMBER $NUM_SLAVES 
		#cd $THIS_DIR

#COLLECTION MICRO SERVICE

COLLECT_VOLUME=${HOST_VOLUME}/Data  						# Volume on Host to Mount 
COLLECT_IO="/root/output"							# Data Output Directory on Container - Must be empty before container starts. 
COLLECT_BACK=$UBUNTU_BACK							# Backend To Use (2 available: Hadoop and Ubuntu)
COLLECT_IMAGE="app/app:collect"							# Application Image Name
COLLECT_COMMAND="\"-c\", \"cd ${COLLECT_IO} && /root/collect.sh; exit\""	# Application Run Command
COLLECT_DIR="${APP_DIR}/collectionApp"						# Directory on Host Where Application Exists

#Make Application
#This attaches the application files to the correct environment
#USAGE: Backend Image -- Application Files -- Command -- Application Image Tag

./make-app.sh $COLLECT_BACK $COLLECT_DIR "${COLLECT_COMMAND}" $COLLECT_IMAGE /root

#DEPENDENCY RESOLUTION
sudo docker stop collect
sudo docker rm collect	

#Run Application
sudo docker run --rm --name="collect" -v ${COLLECT_VOLUME}:${COLLECT_IO} -it $COLLECT_IMAGE

#RUN1 MICROSERVICE

RUN1_VOLUME=${HOST_VOLUME}/Data                           
RUN1_IO="/big/medicare-demo/ref_data"                      
RUN1_BACK=$HADOOP_BACK                               
RUN1_IMAGE="app/app:run1"                                    
RUN1_COMMAND="\"-c\", \"service ssh start && sleep 10 && /root/start-hadoop.sh && cd /big/medicare-demo && /big/medicare-demo/run1.sh 10 && cd /big/medicare-demo/ref_data && hadoop fs -get /user/root/medicare_10; exit\""   
RUN1_DIR="${APP_DIR}/preprocessApp"                           

#USAGE: Backend Image -- Application Files -- Command -- Application Image Tag -- Workdir
./make-app.sh $RUN1_BACK $RUN1_DIR "${RUN1_COMMAND}" $RUN1_IMAGE /big/medicare-demo

#DEPENDENCY RESOLUTION

while [[ $(sudo docker inspect -f {{.State.Running}} "collect") = true ]]
do
	echo "waiting for data collection to finish" 	
        sleep 10 
done

#Run Application
CLUSTER_NUMBER=1
NUM_SLAVES=3

		cd ${BACKEND_DIR}/hadoop/scripts/
		./configure.sh $CLUSTER_NUMBER $NUM_SLAVES
		./build-images.sh $CLUSTER_NUMBER $NUM_SLAVES 
		cd $THIS_DIR

./init-containers.sh $CLUSTER_NUMBER $NUM_SLAVES $RUN1_IMAGE $RUN1_VOLUME $RUN1_IO

#RUN2 MICROSERVICE

RUN2_VOLUME=${HOST_VOLUME}/Data                           
RUN2_IO="/big/medicare-demo/ref_data"                      
RUN2_BACK=$HADOOP_BACK                               
RUN2_IMAGE="app/app:run2"                                    
RUN2_COMMAND="\"-c\", \"service ssh start && sleep 10 && /root/start-hadoop.sh && cd /big/medicare-demo/ref_data && hadoop fs -get medicare_10 && cd /big/medicare-demo && /big/medicare-demo/run2.sh 10; exit\""   
RUN2_DIR="${APP_DIR}/postprocessApp"                           

#USAGE: Backend Image -- Application Files -- Command -- Application Image Tag -- Workdir
./make-app.sh $RUN2_BACK $RUN2_DIR "${RUN2_COMMAND}" $RUN2_IMAGE /big/medicare-demo

#Run Application
CLUSTER_NUMBER=2
NUM_SLAVES=10

		cd ${BACKEND_DIR}/hadoop/scripts/
		./configure.sh $CLUSTER_NUMBER $NUM_SLAVES
		./build-images.sh $CLUSTER_NUMBER $NUM_SLAVES 
		cd $THIS_DIR

#DEPENDENCY RESOLUTION
while [[ $(sudo docker inspect -f {{.State.Running}} "hadoop1-master") = true ]]
do
	echo "waiting for run1" 	
        sleep 300 
done

./init-containers.sh $CLUSTER_NUMBER $NUM_SLAVES $RUN2_IMAGE $RUN2_VOLUME $RUN2_IO


