#!/bin/bash
sudo setenforce 0
sudo yum install wget vim telnet nmap zip unzip -y

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which java)))))
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar

sudo mkdir -p /mnt/artefact/
sudo chmod 777 -R /mnt/artefact/
