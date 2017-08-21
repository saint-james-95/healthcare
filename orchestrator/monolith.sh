DATA_DIR="${HOME}/Use-Case-Healthcare/data"
RESULTS_FILE="${HOME}/Use-Case-Healthcare/output/results.txt"
PCT=1

# Microservice 1
# ./collectMS.sh $DATA_DIR

# Microservice 2
# ./preprocessMS.sh 1 2 $PCT $DATA_DIR 
# sudo docker exec -ti hadoop1-master sh -c "cd /big/medicare-demo/ref_data && hadoop fs -get medicare_\$PCT"

# Microservice 3
ANALYZE_CMD="\"-c\" \"service ssh start && ./start-hadoop.sh && cd /big/medicare-demo/ref_data && hadoop fs -put medicare_\\\$PCT && cd /big/medicare-demo && run2.sh \\\$PCT \>\> /big/medicare-demo/output.txt; bash\""
./analyzeMS.sh 2 10 $PCT $DATA_DIR $RESULTS_FILE "$ANALYZE_CMD" 
