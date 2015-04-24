#!/bin/bash 
if ! [ -f android-cts-4.4_r3-linux_x86-arm.zip ]; then
	wget https://dl.google.com/dl/android/cts/android-cts-4.4_r3-linux_x86-arm.zip
fi

#create image
if [ "$1" == "clear" ];then
	sudo docker build --no-cache=true -t jimlin95/cts_files:v44R3 .
else
	sudo docker build -t jimlin95/cts_files:v44R3 .
fi
