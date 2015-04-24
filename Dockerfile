FROM ubuntu:14.04

MAINTAINER Jim Lin <jim_lin@quantatw.com>

ADD apt.conf /etc/apt/
RUN apt-get update -qq

# Dependencies to execute android
RUN apt-get install -y --no-install-recommends unzip

# Add user jenkins to the image
RUN adduser --quiet jenkins 
RUN adduser jenkins sudo
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

USER jenkins

# Install cts media files
ADD android-cts-4.4_r3-linux_x86-arm.zip /home/jenkins/
RUN cd /home/jenkins && unzip android-cts-4.4_r3-linux_x86-arm.zip 
RUN cd /home/jenkins && rm -f android-cts-4.4_r3-linux_x86-arm.zip 

USER root

# Cleaning
RUN apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/home/jenkins/android-cts"]
