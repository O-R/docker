FROM ubuntu:20.04

RUN apt update \ 
    && apt install software-properties-common \
    && add-apt-repository --yes --update ppa:ansible/ansible \
    && apt install ansible
