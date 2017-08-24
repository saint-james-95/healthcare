DATA_DIR="${HOME}/Use-Case-Healthcare/data"
RESULTS_DIR="${HOME}/Use-Case-Healthcare/output"
RESULTS_FILE="${RESULTS_DIR}/results.txt"
PCT=1
mkdir -p $RESULTS_DIR
sudo touch $RESULTS_FILE

# Microservice 1
# Input - Data dir on host to put datasets
# Output - Datasets to host directory
# Before starting - volume mount $DATA_DIR
# Once finished - nothing to do, remove container

# Runs Interactively
# ./collectMS.sh $DATA_DIR

# Deletes itself when finished
sudo docker rm collector

# Microservice 2
# Input - Cluster Number (to have more than one cluster)
#       - Number of slaves
#       - Percentage of dataset to process
#       - Data dir for dataset 

# Output - medicare_$PCT in /user/root, in HDFS
# Before starting - volume mount $DATA_DIR to /big/medicare-demo/ref_data
# Once finished - orchestrator extracts output to $DATA_DIR

# Runs Detached (Needed to execute commands after main process)
./preprocessMS.sh 1 5 $PCT $DATA_DIR

while : ; do

        STATUS=`sudo docker exec hadoop1-master bash -c "ps -NT | tail -1"`
        STATUS=`echo "$STATUS" | awk '{ print \$NF }'`

        #Done once we return to the shell
        if [[ $STATUS = "bash" ]]; then
                break
        fi
        echo "waiting for preprocessing to finish. You can check the containers activities with sudo docker logs --follow hadoop1-master"
        sleep 300
done

#Move files to Linux Kernel Filesystem
sudo docker exec -ti hadoop1-master sh -c "cd /big/medicare-demo/ref_data && hadoop fs -get medicare_\$PCT"

# Microservice 3
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

# Runs Interactively
ANALYZE_CMD="\"-c\" \"service ssh start && ./start-hadoop.sh && cd /big/medicare-demo/ref_data && hadoop fs -put medicare_\\\$PCT && cd /big/medicare-demo && ./run2.sh \\\$PCT >> /big/medicare-demo/output.txt; bash\""
./analyzeMS.sh 2 10 $PCT $DATA_DIR $RESULTS_FILE "$ANALYZE_CMD"

