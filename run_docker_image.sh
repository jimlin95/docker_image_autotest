#!/bin/bash
#run docker
docker run --name cts_test --privileged -v /dev/bus/usb:/dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix -d -p 2222:22 jimlin95/cts_x86:v5R2
