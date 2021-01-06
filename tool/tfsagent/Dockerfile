From ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /var/run/sshd
COPY ./sources.list /etc/apt/
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
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
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
&& add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
        nodejs \
        tzdata \
        docker-ce docker-ce-cli containerd.io \
&& rm -rf /var/lib/apt/lists/* \
&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#RUN echo "199.232.96.133 raw.githubusercontent.com" >> /etc/hosts
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "root:123456" | chpasswd
EXPOSE 22
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /azp
#RUN wget -nv https://vstsagentpackage.azureedge.net/agent/2.179.0/vsts-agent-linux-x64-2.179.0.tar.gz -O vsts-agent-linux-x64-2.153.1.tar.gz
RUN wget -nv https://vstsagentpackage.azureedge.net/agent/2.153.1/vsts-agent-linux-x64-2.153.1.tar.gz
COPY ./nginx-1.18.0-compile.tar.gz .
#COPY ./vsts-agent-linux-x64-2.153.1.tar.gz .
COPY ./start.sh .
RUN chmod +x start.sh
RUN useradd -s /sbin/nologin -M nginx

CMD ["./start.sh"]
#CMD ["/usr/bin/supervisord"]
