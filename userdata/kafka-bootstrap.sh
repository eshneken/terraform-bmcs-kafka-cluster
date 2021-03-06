#!/bin/bash

# stop linux firewall
sudo service firewalld stop
sudo systemctl disable firewalld

# disable SELinux
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0

# get required packages via yum and download kafka from mirror
sudo yum update -y
sudo yum -y install java-1.8.0-openjdk
sudo yum -y install wget
mkdir -p ~opc/kafka-download
wget "http://redrockdigimark.com/apachemirror/kafka/0.10.1.0/kafka_2.11-0.10.1.0.tgz" -O ~opc/kafka-download/kafka-binary.tgz
mkdir -p ~opc/kafka-install && cd ~opc/kafka-install
tar -xvzf ~opc/kafka-download/kafka-binary.tgz --strip 1
