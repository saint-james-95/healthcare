# USAGE: $1 = Data Directory On Host Machine, $2 = Year (2012-2015) of Medicare Data to Analyze
# DESCRIPTION: Gather the three datasets & make available on the host machine

CONTAINER_NAME="collector"
DATA_DIR="$1"
MEDICARE_YEAR="$2"

# Adjust For Appropriate Link to Dataset
if [ "$MEDICARE_YEAR" = 2012 ]; then
	MEDICARE_YEAR="2012_update"
fi

# Stop and delete if container already exists
docker stop $CONTAINER_NAME &> /dev/null
docker rm $CONTAINER_NAME &> /dev/null

# Choose datasets to collect
NPI=true
NUCC=true
MEDICARE=true

# Run Microservice
docker run -it \
		--privileged=true \
		--name $CONTAINER_NAME \
		-e "NPI=$NPI" \
		-e "NUCC=$NUCC" \
		-e "MEDICARE=$MEDICARE" \
		-e "MEDICARE_YEAR=$MEDICARE_YEAR" \
		-v ${DATA_DIR}:/root/output nbdif/healthcare:app_collect

