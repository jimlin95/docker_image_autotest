#!/bin/bash
#create image
if [ "$1" == "clear" ];then
	sudo docker build --no-cache=true -t jimlin95/androidviewclient:v1 . 
else
	sudo docker build -t jimlin95/androidviewclient:v1 .
fi
