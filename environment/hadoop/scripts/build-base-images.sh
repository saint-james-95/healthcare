#Build the base slave and master images for all hadoop clusters. 

THIS_DIR=$PWD

cd $HOME/Use-Case-Healthcare/environment/hadoop/dockerfiles

#Base image, shared by slave and master
cd base-slave
docker build -t nbdif/healthcare:hadoop_slave_base .

#Extra programs for the master
cd ..
cd base-master
docker build -t nbdif/healthcare:hadoop_master_base .

cd $THIS_DIR
