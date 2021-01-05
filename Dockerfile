From ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /var/run/sshd
COPY ./sources.list /etc/apt/
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        libssl1.0 \
        build-essential \
        perl \
        libperl-dev \
        libgd3 \
        libgd-dev \
        libgeoip1 \
        libgeoip-dev \
        geoip-bin \
        libxml2 \
        libxml2-dev \
        libxslt1.1 \
        libxslt1-dev \
        openssh-server vim tar wget curl rsync bzip2 iptables tcpdump less telnet net-tools lsof sysstat cron supervisor \
        openjdk-8-jdk 

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash \
&& apt-get install -y --no-install-recommends nodejs \
        tzdata \
&& rm -rf /var/lib/apt/lists/* \
&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#RUN echo "199.232.96.133 raw.githubusercontent.com" >> /etc/hosts
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "root:123456" | chpasswd
EXPOSE 22
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /azp

COPY ./nginx-1.18.0-compile.tar.gz .
COPY ./vsts-agent-linux-x64-2.153.1.tar.gz .
COPY ./start.sh .
RUN chmod +x start.sh
RUN useradd -s /sbin/nologin -M nginx

CMD ["./start.sh"]
#CMD ["/usr/bin/supervisord"]