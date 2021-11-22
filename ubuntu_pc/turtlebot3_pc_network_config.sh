#!/bin/bash

# remove previous network environmental export variables
read -t 2 -p "Getting host IP address and setting up network parameters..."

ipa=$(hostname -I|cut -f1 -d ' ')

user_shell=$(echo $SHELL)
shell=$(echo ${user_shell} | cut -f4 -d '/')

ROS_MASTER="export ROS_MASTER_URI=http://${ipa}:11311"
ROS_HOSTNAME="export ROS_HOSTNAME=${ipa}"

#sed '/ROS_/d' ~/.${shell}rc > .tmpfile && rm ~/.${shell}rc && mv .tmpfile ~/.${shell}rc

#echo "export ROS_MASTER_URI=http://${ipa}:11311" >> ~/.${shell}rc
#echo "export ROS_HOSTNAME=${ipa}" >> ~/.${shell}rc
if  grep -q "ROS_MASTER" ~/.${shell}rc || grep -q "ROS_HOSTNAME" ~/.${shell}rc;
	then
		sed -i "s+export ROS_MASTER.*+${ROS_MASTER}+g" ~/.${shell}rc
		sed -i "s+export ROS_HOSTNAME.*+${ROS_HOSTNAME}+g" ~/.${shell}rc
	else
		echo ${ROS_MASTER} >> ~/.${shell}rc
		echo ${ROS_HOSTNAME} >> ~/.${shell}rc
	fi

echo "
Turtlebot3 host machine ROS network settings updated.
Now run following command in terminal to update terminal:

	source ~/.${shell}rc

REMOTE_IP paramater required when setting up ROS_MASTER_URI in turtlebot3 is:

	echo ${ipa}

Note: Ensure firewall allows traffic between PC and Turtlebot3 in order to avoid connection failure.
"
