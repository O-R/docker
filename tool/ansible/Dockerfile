FROM ubuntu:20.04

RUN apt update \ 
    && apt install -y software-properties-common \
    && add-apt-repository --yes --update ppa:ansible/ansible \
    && apt install -y ansible iproute2 iputils-arping net-tools tcpdump curl \
           telnet iputils-tracepath traceroute bridge-utils ethtool \
           vim tar wget iptables ipvsadm inetutils-ping \
    && rm -rf /var/lib/apt/lists/*

