#!/bin/bash
#run docker
docker run --name autotest --privileged -v /dev/bus/usb:/dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix -d -p 2222:22 jimlin95/androidviewclient:v1
