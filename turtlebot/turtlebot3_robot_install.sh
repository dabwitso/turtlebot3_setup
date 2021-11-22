#!/bin/bash

sudo dpkg --add-architecture armhf
sudo apt-get update
sudo apt-get install libc6:armhf -y

echo "



To ensure installation was successfully completed, in terminal run:

		sudo apt-get install libc6:armhf



If you encountered a 'lock dpkg' error message, then kill the unintended program.

		sudo kill -9 [PID]



replace [PID] with the ID number of the process that is running unintended. Then retry running:

		sudo apt-get install libc6:armhf



Once completed, run:

		./opencr_setup.sh
"
