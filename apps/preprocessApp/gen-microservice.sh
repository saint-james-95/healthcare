THIS_DIR=$PWD
cd ~/Use-Case-Healthcare/environment/hadoop/scripts
./configure.sh 1 5
./build-images.sh 1
cd $THIS_DIR
sudo docker build -t app:preprocess .
