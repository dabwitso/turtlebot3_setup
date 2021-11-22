#!/bin/bash

while getopts ":m:h" opt;
do
	case ${opt} in
		h)
			echo "Usage ./opencr_setup.sh -m [type]"
			echo " -h 	--help"
			echo " -m		--type 	type of turtlebot3, either burger or waffle"
			exit 0;;
		m)
			TURTLEBOT_TYPE=${OPTARG};;
		\?)
			echo "Invalid Option: -${OPTARG}" 1>&2
			./opencr_setup.sh -h
			exit 1;;
	esac
done

if [ -z TURTLEBOT_TYPE ]
then
	echo "-m [type] option is required. Check usage below"
	./opencr_setup.sh -h
	exit 1
fi

export OPENCR_PORT=/dev/ttyACM0
export OPENCR_MODEL=${TURTLEBOT_TYPE}_${ROS_DISTRO}
rm -rf ../../opencr_update.tar.bz2

read -t 2 -p "Fetching data online..."
wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS1/latest/opencr_update.tar.bz2

tar -xvf opencr_update.tar.bz2

cd opencr_update/
./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr
echo "

opencr setup completed! Have fun running Turtlebot3
"
