#!/bin/bash

# set network parameters for wifi

CONFIG_FILE=/etc/netplan/50-cloud-init.yaml

while getopts ":s:p:n:a:h" opt;
do
	case ${opt} in
		h)
			echo "Usage: ./turtlebot3_robot_config.sh [options...]"
			echo "	-h	--help"
			echo "	-s	--wifi_SSID    Insert wifi ssid. Only required for wifi connection"
			echo "	-p	--wifi_password    Insert wifi password. Only required for wifi connection"
			echo "	-n	--network (wifi/lan)    Select connection type"
			echo "	-a	--remote_IP    IP address of remote pc controlling Turtlebot"
			exit 0
			;;
		n)
			MODE=${OPTARG};;
		s)
			echo "Press [ENTER] to continue, [CTRL] + C to exit"
			read
			SSID=${OPTARG};;
		p)
			PASSWORD=${OPTARG};;
		a)
			REMOTE_IP=${OPTARG};;
		\?)
			echo "Invalid Option: -${OPTARG}" 1>&2
			./turtlebot3_network_config.sh -h
			exit 1
			;;
	esac
done

if [[ -z ${MODE} || -z ${REMOTE_IP} ]]
then
	echo "-n [mode] and -a [remote_IP] options required. Check usage"
	./turtlebot3_network_config.sh -h
	exit 1
fi

ipa=$(hostname -I|cut -f1 -d ' ')
ROS_MASTER="export ROS_MASTER_URI=http://${REMOTE_IP}:11311"
ROS_HOSTNAME="export ROS_HOSTNAME=${ipa}"

# WIFI only configuration
if [ ${MODE} = "wifi" ]
then
	if [[ -z ${SSID} || -z ${PASSWORD} ]]
	then
		echo "Wifi SSID and PASSWORD required when -n [mode] is wifi. Check usage"
		./turtlebot3_network_config.sh -h
		exit 1
	fi

	sudo sed -i "s+WIFI_SSID:+${SSID}:+g" ${CONFIG_FILE}
	sudo sed -i "s+password.*+password: ${PASSWORD}+g" ${CONFIG_FILE}
fi

# wifi and LAN configurations


if  grep -q "ROS_MASTER" ~/.bashrc || grep -q "ROS_HOSTNAME" ~/.bashrc;
then
	sed -i "s+export ROS_MASTER.*+${ROS_MASTER}+g" ~/bashrc
	sed -i "s+export ROS_HOSTNAME.*+${ROS_HOSTNAME}+g" ~/.bashrc
else
	echo ${ROS_MASTER} >> ~/.bashrc
	echo ${ROS_HOSTNAME} >> ~/.bashrc
fi


echo "
Turtlebot3 Raspberry Pi network setup completed.
Now run following command in terminal to update terminal:

		source ~/.bashrc

"
