cd ../image-building

#Base image, shared by slave and master
cd base
sudo docker build -t environment:base .

#Extra programs for the master
cd ..
cd base-master
sudo docker build -t environment:base-master .
