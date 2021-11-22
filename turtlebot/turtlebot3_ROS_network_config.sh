#!/bin/bash

# set network parameters for ROS

while getopts ":s:p:n:a:h" opt;
do
	case ${opt} in
		h)
			echo "Usage: ./turtlebot3_robot_config.sh [options...]"
			echo "	-h	--help"
			echo "	-a	--remote_IP    IP address of remote pc controlling Turtlebot"
			exit 0
			;;
		a)
			REMOTE_IP=${OPTARG};;
		\?)
			echo "Invalid Option: -${OPTARG}" 1>&2
			./turtlebot3_ROS_network_config.sh -h
			exit 1
			;;
	esac
done

if [ -z ${REMOTE_IP} ]
then
	echo "-n [mode] and -a [remote_IP] options required. Check usage"
	./turtlebot3_ROS_network_config.sh -h
	exit 1
fi

ipa=$(hostname -I|cut -f1 -d ' ')
ROS_MASTER="export ROS_MASTER_URI=http://${REMOTE_IP}:11311"
ROS_HOSTNAME="export ROS_HOSTNAME=${ipa}"



# wifi and LAN configurations


if  grep -q "ROS_MASTER" ~/.bashrc || grep -q "ROS_HOSTNAME" ~/.bashrc;
then
	sed -i "s+export ROS_MASTER.*+${ROS_MASTER}+g" ~/.bashrc
	sed -i "s+export ROS_HOSTNAME.*+${ROS_HOSTNAME}+g" ~/.bashrc
else
	echo ${ROS_MASTER} >> ~/.bashrc
	echo ${ROS_HOSTNAME} >> ~/.bashrc
fi


echo "
Turtlebot3 ROS network parameters setup completed.
Now run following command in terminal to update terminal:

source ~/.bashrc

"
