#Usage: $1 = Cluster Identifying Number , must be 1 - 9
#Image tags have this number as the last character in the tag name    

THIS_DIR=$PWD

cd $HOME/Use-Case-Healthcare/environment/hadoop/dockerfiles

#Configured Slave Image
cd slave
docker build -t environment:slave$1 .

#Configured Master Image 
cd ..
cd master
docker build -t environment:master$1 .

cd $THIS_DIR
