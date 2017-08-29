THIS_DIR=$PWD
cd ~/Use-Case-Healthcare/environment/hadoop/scripts
./configure.sh 2 10
./build-images.sh 2
cd $THIS_DIR
sudo docker build -t app:analyze .
