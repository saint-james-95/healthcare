DATA_DIR="~/Use-Case-Healthcare/data"
RESULTS_DIR="~/Use-Case-Healthcare/results"
PCT=1

./collectMS.sh $DATA_DIR
#KILL
./preprocessMS.sh 1 2 $PCT $DATA_DIR
sudo docker exec -ti hadoop1-master sh -c "cd /big/medicare-demo/ref_data && hadoop fs -get /user/root"
#KILL

CMD=$(sudo docker inspect -f '{{.Config.Cmd}}' app:postprocess | tr "[" \" | tr "]" \" | sed 's/\"-c /\"-c\" \"/g')
CMD=${CMD/.\/start-hadoop.sh/.\/start-hadoop.sh && cd \/big\/medicare-demo\/ref_data && hadoop fs -put medicare_\$PCT}

./analyzeMS.sh 2 2 $PCT $DATA_DIR $CMD 
#KILL
