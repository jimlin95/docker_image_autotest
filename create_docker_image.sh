#!/bin/bash 
if ! [ -f android-cts-media-1.1.zip ]; then
	wget https://dl.google.com/dl/android/cts/android-cts-media-1.1.zip
fi
#create image
if [ "$1" == "clear" ];then
	sudo docker build --no-cache=true -t jimlin95/cts_mediafiles:v1.1 .
else
	sudo docker build -t jimlin95/cts_mediafiles:v1.1 .
fi
