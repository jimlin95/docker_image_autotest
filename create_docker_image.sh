#!/bin/bash
#create image
if [ "$1" == "clear" ];then
	sudo docker build --no-cache=true -t jimlin95/automated_test:v1 .
else
	sudo docker build -t jimlin95/automated_test:v1 .
fi
