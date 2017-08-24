sudo docker pull nbdif/healthcare:app_analyze 
sudo docker pull nbdif/healthcare:app_preprocess 
sudo docker pull nbdif/healthcare:app_collect 
sudo docker pull nbdif/healthcare:env_master2 
sudo docker pull nbdif/healthcare:env_slave2 
sudo docker pull nbdif/healthcare:env_master1 
sudo docker pull nbdif/healthcare:env_slave1 

sudo docker tag nbdif/healthcare:app_analyze app:analyze
sudo docker tag nbdif/healthcare:app_preprocess app:preprocess
sudo docker tag nbdif/healthcare:app_collect app:collect
sudo docker tag nbdif/healthcare:env_master2 environment:master2
sudo docker tag nbdif/healthcare:env_slave2 environment:slave2
sudo docker tag nbdif/healthcare:env_master1 environment:master1
sudo docker tag  nbdif/healthcare:env_slave1 environment:slave1

