#!/bin/bash

CONFIG_FILE=/media/${USER}/writable/etc/netplan/50-cloud-init.yaml

while getopts ":s:p:h" opt;
do
	case ${opt} in
		h)
			echo "Usage: ./turtlebot3_robot_config.sh [options...]"
			echo "	-h	--help"
			echo "	-s	--wifi_SSID"
			echo "	-p	--wifi_password"
			exit 0
			;;
		s)
			SSID=${OPTARG};;
		p)
			PASSWORD=${OPTARG};;
		\?)
			echo "Invalid Option: -${OPTARG}" 1>&2
			./turtlebot3_sdcard_config.sh -h
			exit 1
			;;
	esac
done


if [[ -z ${SSID} || -z ${PASSWORD} ]]
then
	echo "-s [SSID] or -p [password] not set. Check usage below:"
	./turtlebot3_sdcard_config.sh -h
	exit 1
fi
sudo sed -i "s+WIFI_SSID:+${SSID}:+g" ${CONFIG_FILE}
sudo sed -i "s+password.*+password: ${PASSWORD}+g" ${CONFIG_FILE}
echo "

Turtlebot3 wifi setup completed"
