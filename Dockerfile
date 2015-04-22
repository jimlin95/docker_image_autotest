FROM ubuntu:14.04

MAINTAINER Jim Lin <jim_lin@quantatw.com>

ADD apt.conf /etc/apt/
RUN apt-get update -qq

# Dependencies to execute android
RUN apt-get install -y --no-install-recommends lib32ncurses5 lib32stdc++6 git wget unzip ca-certificates

# Install a basic SSH server
RUN apt-get install -y --no-install-recommends openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
# Install Python setup tools
RUN apt-get install -y --no-install-recommends  python-setuptools

# Install Library for culebra tools
#RUN apt-get install -y --no-install-recommends python-imaging python-imaging-tk

# Install Java
ADD jdk-6u45-linux-x64.bin /opt/
RUN chmod a+x /opt/jdk-6u45-linux-x64.bin
RUN cd /opt && /opt/jdk-6u45-linux-x64.bin 
RUN cd /opt && rm -f jdk-6u45-linux-x64.bin


ENV https_proxy=http://10.241.104.240:5678/
ENV http_proxy http://10.241.104.240:5678/
# Main Android SDK
RUN cd /opt && wget -q http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz
RUN cd /opt && tar xzf android-sdk_r24.1.2-linux.tgz
RUN cd /opt && rm -f android-sdk_r24.1.2-linux.tgz

# SET ENV
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/jdk1.6.0_45/bin

# Install tools
RUN echo y | android update sdk --filter platform-tools,extra-android-support --no-ui --force

# Add user jenkins to the image
RUN adduser --quiet jenkins 
RUN adduser jenkins sudo
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

USER jenkins
# Add files for development environment
RUN mkdir -p /home/jenkins/.ssh
ADD config /home/jenkins/.ssh/
#RUN chown jenkins:jenkins -R /home/jenkins/.ssh
ADD .gitconfig /home/jenkins/
#RUN chown jenkins:jenkins /home/jenkins/.gitconfig
ADD .bashrc /home/jenkins/
ADD .profile /home/jenkins/ 

# Install cts media files
ADD android-cts-media-1.1.zip /home/jenkins/
#RUN cd /home/jenkins && wget -q https://dl.google.com/dl/android/cts/android-cts-media-1.1.zip
RUN cd /home/jenkins && unzip android-cts-media-1.1.zip
RUN cd /home/jenkins && rm -f android-cts-media-1.1.zip

# Install CTS 
ADD  android-cts-4.4_r3-linux_x86-arm.zip /home/jenkins/
#RUN cd /home/jenkins/ && wget -q https://dl.google.com/dl/android/cts/android-cts-4.4_r3-linux_x86-arm.zip
RUN cd /home/jenkins && unzip  android-cts-4.4_r3-linux_x86-arm.zip 
RUN cd /home/jenkins && rm -f android-cts-4.4_r3-linux_x86-arm.zip 


# Install Androidviewclient
RUN git clone https://github.com/jimlin95/automated_test.git /home/jenkins/automated_test
RUN chown jenkins:jenkins -R /home/jenkins/automated_test

USER root
RUN cd /home/jenkins/automated_test/AndroidViewClient && python ./setup.py install
RUN chown jenkins:jenkins -R /opt/android-sdk-linux  

# Cleaning
RUN apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
