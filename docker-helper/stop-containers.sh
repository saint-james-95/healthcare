sudo docker stop $(sudo docker ps -a -f "name=$1" | tail -n +2 | awk '{print $NF}')
