FROM ubuntu:16.04
#RUN mkdir -p /var/run/sshd
RUN apt-get update && apt-get update \
    && apt-get install -y openssh-server vim tar wget curl rsync bzip2 iptables tcpdump less \
        telnet net-tools lsof sysstat cron supervisor inetutils-ping git xclip hping3 dnsutils\
    && rm -rf /var/lib/apt/lists/*
#RUN sed -i s/"PermitRootLogin without-password"/"PermitRootLogin yes"/g /etc/ssh/sshd_config
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#EXPOSE 22
#COPY sshd.conf /etc/supervisor/conf.d/sshd.conf
#CMD ["/usr/bin/supervisord"]
