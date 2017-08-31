cd ../image-building

#Base + Slave Configuration
cd slave
sudo docker build -t environment:slave$1 .

#Base-master + Master Configuration 
cd ..
cd master
sudo docker build -t environment:master$1 .

