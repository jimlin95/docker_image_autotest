#!/bin/bash 
if ! [ -f  "android-cts-5.0_r2-linux_x86-x86.zip" ]; then
	wget https://dl.google.com/dl/android/cts/android-cts-5.0_r2-linux_x86-x86.zip
fi

if ! [ -f android-cts-media-1.1.zip ]; then
	wget https://dl.google.com/dl/android/cts/android-cts-media-1.1.zip
fi
#create image
if [ "$1" == "clear" ];then
	sudo docker build --no-cache=true -t jimlin95/cts_x86:v5R2 .
else
	sudo docker build -t jimlin95/cts_x86:v5R2 .
fi
