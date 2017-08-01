if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Missing Arguments"
    exit 1
fi

sudo ./configure.sh $1 $2
sudo ./build-images.sh $1 $2
sudo ./init-containers.sh $1 $2
