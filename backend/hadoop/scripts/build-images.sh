cd ../image-building

#Base image, shared by slave and master
cd base
#sudo docker build -t saintjames95/hadoop:base .

#Extra programs for the master
cd ..
cd base-master
#sudo docker build -t saintjames95/hadoop:base-master .

#Base + Slave Configuration
cd ..
cd slave
sudo docker build -t backend/backend:slave .

#Base-master + Master Configuration 
cd ..
cd master
sudo docker build -t backend/backend:master .
