cd base
sudo docker build -t saintjames95/hadoop:base .

cd ..
cd base-master
sudo docker build -t saintjames95/hadoop:base-master .

cd ..
cd base-config
sudo docker build -t saintjames95/hadoop:base-config .

cd ..
cd base-master-config
sudo docker build -t saintjames95/hadoop:base-master-config .
