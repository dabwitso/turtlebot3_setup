#!/bin/bash

VERSION=$(lsb_release -a | grep Codename | cut -f2 -d ":")
echo "Ubuntu ${VERSION} detected"


user_shell=$(echo $SHELL)
shell=$(echo ${user_shell} | cut -f4 -d '/')
ipa=$(hostname -I|cut -f1 -d ' ')
ROS_MASTER="export ROS_MASTER_URI=http://${ipa}:11311"
ROS_HOSTNAME="export ROS_HOSTNAME=${ipa}"
CURRENT_DIR=${PWD}

if [ -z ${ROS_DISTRO} ]
then
	chmod +x install_ros.sh
	read -t 1 -p "No ros installation detected..."
	read -t 1 -p "Starting to install Ros packages..."
	./install_ros.sh
	read -t 1 -p "${ROS_DISTRO} installed successfully. "
fi


read -t 2 -p "Installing dependencies..."
echo ""
if [[ ${ROS_DISTRO} = "melodic" || ${ROS_DISTRO} = "noetic" ]]
then
	sudo apt-get install ros-${ROS_DISTRO}-joy ros-${ROS_DISTRO}-teleop-twist-joy \
		ros-${ROS_DISTRO}-teleop-twist-keyboard ros-${ROS_DISTRO}-laser-proc \
		ros-${ROS_DISTRO}-rgbd-launch ros-${ROS_DISTRO}-rosserial-arduino \
		ros-${ROS_DISTRO}-rosserial-python ros-${ROS_DISTRO}-rosserial-client \
		ros-${ROS_DISTRO}-rosserial-msgs ros-${ROS_DISTRO}-amcl ros-${ROS_DISTRO}-map-server \
		ros-${ROS_DISTRO}-move-base ros-${ROS_DISTRO}-urdf ros-${ROS_DISTRO}-xacro \
		ros-${ROS_DISTRO}-compressed-image-transport ros-${ROS_DISTRO}-rqt* ros-${ROS_DISTRO}-rviz \
		ros-${ROS_DISTRO}-gmapping ros-${ROS_DISTRO}-navigation ros-${ROS_DISTRO}-interactive-markers \
		net-tools \
		unzip -y

	echo "


	"
	read -t 2 -p "Installing TurtleBot3 packages..."

	sudo apt install ros-${ROS_DISTRO}-dynamixel-sdk -y
	sudo apt install ros-${ROS_DISTRO}-turtlebot3-msgs -y
	sudo apt install ros-${ROS_DISTRO}-turtlebot3 -y



	if [ ${VERSION}="focal" ]
	then
		echo "


		"
		read -t 2 -p "Unzipping Turtlebot3 Raspberry Pi image for Ubuntu 20.04(${VERSION}) "
		unzip ../os_images/noetic.zip -d ../os_images
		rm -r ../os_images/noetic.zip
		rm -r ../os_images/melodic.zip
	elif [ ${VERSION} = "bionic" ]
	then
		echo "


		"
		read -t 2 -p "Unzipping Turtlebot3 Raspberry Pi image for Ubuntu 18.04(${VERSION}) "
		unzip ../os_images/melodic.zip -d ../os_images
		rm -r ../os_images/noetic.zip
		rm -r ../os_images/melodic.zip
	fi


	echo "


	"
	read -t 2 -p "Getting host IP address and setting up ~/.${shell}rc parameter..."

	if  grep -q "ROS_MASTER" ~/.${shell}rc || grep -q "ROS_HOSTNAME" ~/.${shell}rc;
	then
		sed -i "s+export ROS_MASTER.*+${ROS_MASTER}+g" ~/.${shell}rc
		sed -i "s+export ROS_HOSTNAME.*+${ROS_HOSTNAME}+g" ~/.${shell}rc
	else
		echo ${ROS_MASTER} >> ~/.${shell}rc
		echo ${ROS_HOSTNAME} >> ~/.${shell}rc
	fi

	echo "


	"

	read -t 2 -p "Downloading and building Turtlebot3	nodes for simulation or interaction with real Turtlebot3..."

	mkdir -p ~/turtlebot3_ws/src && cd ~/turtlebot3_ws/src

	if [ ${VERSION}="focal" ]
	then
		git clone -b noetic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git
	elif [ ${VERSION} = "bionic" ]
	then
		git clone -b melodic-devel https://github.com/ROBOTIS-GIT/turtlebot3.git
	fi

	cd ~/turtlebot3_ws/ && catkin_make && echo "source ~/turtlebot3_ws/devel/setup.${shell}" >> ~/.${shell}rc


	echo "


	Turtlebot3 host machine setup successful.

	Now run following command in terminal to update terminal:

					source ~/.${shell}rc

	Run following script everytime you reboot your pc in order to update IP address settings:

					./turlebot3_pc_config.sh

	Use following IP address on Turtlebot configuration as ROS_MASTER_URI:

					${ipa}
	"
else
	echo "This script currently only supports Ubuntu(mint) 18.04 and 20.04.
	......................................................................
	Installation terminated!"
	exit 1
fi


