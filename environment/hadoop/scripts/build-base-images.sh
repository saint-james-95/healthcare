cd $HOME/Use-Case-Healthcare/environment/hadoop/dockerfiles

#Base image, shared by slave and master
cd base-slave
sudo docker build -t environment:base-slave .

#Extra programs for the master
cd ..
cd base-master
sudo docker build -t environment:base-master .
