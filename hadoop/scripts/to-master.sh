if [ -z "$1" ]
  then
    echo "No Cluster Number Supplied"
    exit 1
fi

# get into hadoop master container                                                                                                                                                                                
sudo docker exec -it hadoop${1}-master bash
