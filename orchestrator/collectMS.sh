# USAGE: $1 = Data Dir On Host To Put Data
sudo docker run --name collector -it -v ${1}:/root/output app:collect

