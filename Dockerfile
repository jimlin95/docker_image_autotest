FROM ubuntu:14.04

MAINTAINER Jim Lin <jim_lin@quantatw.com>

ADD apt.conf /etc/apt/
RUN apt-get update -qq

# Dependencies to execute android
RUN apt-get install -y --no-install-recommends openjdk-7-jdk lib32ncurses5 lib32stdc++6 git wget

# Install a basic SSH server
RUN apt-get install -y --no-install-recommends openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
# Install Python setup tools
RUN apt-get install -y --no-install-recommends  python-setuptools

# Install Library for culebra tools
RUN apt-get install -y --no-install-recommends python-imaging python-imaging-tk

ENV https_proxy=http://10.241.104.240:5678/
ENV http_proxy http://10.241.104.240:5678/
# Main Android SDK
RUN cd /opt && wget -q http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz
RUN cd /opt && tar xzf android-sdk_r24.1.2-linux.tgz
RUN cd /opt && rm -f android-sdk_r24.1.2-linux.tgz

# SET ENV
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install tools
RUN echo y | android update sdk --filter platform-tools,extra-android-support --no-ui --force

# Add user jenkins to the image
RUN adduser --quiet jenkins 
RUN adduser jenkins sudo
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Add files for development environment
RUN mkdir -p /home/jenkins/.ssh
ADD config /home/jenkins/.ssh/
RUN chown jenkins:jenkins -R /home/jenkins/.ssh
ADD .gitconfig /home/jenkins/
RUN chown jenkins:jenkins /home/jenkins/.gitconfig
ADD .bashrc /home/jenkins/
ADD .profile /home/jenkins/

# Install Androidviewclient
RUN git clone https://github.com/jimlin95/automated_test.git /home/jenkins/automated_test
RUN chown jenkins:jenkins -R /home/jenkins/automated_test
RUN cd /home/jenkins/automated_test/AndroidViewClient && python ./setup.py install
RUN chown jenkins:jenkins -R /opt/android-sdk-linux  
# Cleaning
RUN apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
