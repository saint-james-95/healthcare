MEDICARE_YEAR=2012
PCT=10
DATA_DIR="${HOME}/Use-Case-Healthcare/data"
RESULTS_DIR="${HOME}/Use-Case-Healthcare/output"
RESULTS_FILE="${RESULTS_DIR}/results_${MEDICARE_YEAR}_${PCT}.txt"
mkdir -p $RESULTS_DIR
sudo touch $RESULTS_FILE

# Microservice 1
# Runs Interactively
# Input - Data directory on host to put datasets && year of medicare data to collect
# Output - Datasets to host directory
# Before starting - volume mount $DATA_DIR
# Once finished - nothing to do

echo "beginning collection microservice..."
./collectMS.sh $DATA_DIR $MEDICARE_YEAR
echo "collection microservice finished"

# Fix file header case for dataset
echo "Fixing Dataset File Header Case Issue..."
sudo sed -i '1s/./\U&/g' ${DATA_DIR}/Medicare_Provider_Util_Payment_PUF_CY${MEDICARE_YEAR}.txt

# Microservice 2
# Runs Detached 
# Input - Cluster Number (to have more than one cluster)
#       - Number of slaves
#       - Percentage of dataset to process
#       - Data dir for dataset 

# Output - medicare_$PCT in /user/root, in HDFS
# Before starting - volume mount $DATA_DIR to /big/medicare-demo/ref_data
# Once finished - orchestrator extracts output to $DATA_DIR

PREPROCESS_CLUSTER_ID=1
PREPROCESS_SLAVES=5
echo "beginning preprocessing microservice..."
./preprocessMS.sh $PREPROCESS_CLUSTER_ID $PREPROCESS_SLAVES $PCT $DATA_DIR

# Check status every 5 minutes, continue once container is waiting in bash shell
echo "waiting for preprocessing to finish. You can check the container's activities with sudo docker logs --follow hadoop1-master"
while : ; do
        STATUS=`sudo docker exec hadoop1-master bash -c "ps -NT | tail -1"`
        STATUS=`echo "$STATUS" | awk '{ print \$NF }'`

        #Done once we return to the shell
        if [[ $STATUS = "bash" ]]; then
                break
        fi
        sleep 300
done
echo "preprocessing microservice finished"

#Move files to Linux Kernel Filesystem
sudo docker exec -ti hadoop1-master sh -c "cd /big/medicare-demo/ref_data && hadoop fs -get medicare_\$PCT"

# Microservice 3
# Runs Detached
# Input - Cluster Number (to have more than one cluster)
#       - Number of slaves
#       - Percentage of dataset to process
#       - Data dir for dataset 
# Output - Personalized PageRank scores to STDOUT
# Before starting - volume mount DATA_DIR
#                 - volume mount RESULTS_FILE
#                 - put DATA_DIR/medicare_$PCT in /user/root in HDFS 
#                 - redirect run2 STDOUT on container to RESULTS_FILE
# Once finished - Nothing to do

# Overwrite Default Command
ANALYZE_CMD="\"-c\" \"service ssh start && ./start-hadoop.sh && cd /big/medicare-demo/ref_data && hadoop fs -put medicare_\\\$PCT && cd /big/medicare-demo && ./run2.sh \\\$PCT >> /big/medicare-demo/output.txt; bash\""


ANALYZE_CLUSTER_ID=2
ANALYZE_SLAVES=10
echo "beginning analytics microservice..."
./analyzeMS.sh $ANALYZE_CLUSTER_ID $ANALYZE_SLAVES $PCT $DATA_DIR $RESULTS_FILE "$ANALYZE_CMD"

# Check status every minute, continue once container is waiting in bash shell
echo "waiting for analytics to finish. You can check the container's activities with sudo docker logs --follow hadoop2-master"
while : ; do
        STATUS=`sudo docker exec hadoop2-master bash -c "ps -NT | tail -1"`
        STATUS=`echo "$STATUS" | awk '{ print \$NF }'`

        #Done once we return to the shell
        if [[ $STATUS = "bash" ]]; then
                break
        fi
        sleep 60
done
echo "analytics microservice finished"
