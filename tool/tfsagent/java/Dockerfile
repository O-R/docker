From ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive

COPY ./sources.list /etc/apt/
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        apt-transport-https ca-certificates curl gnupg lsb-release\
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        libssl1.0 \
        openjdk-8-jdk \
        nodejs \
        tzdata wget curl vim tar zip unzip \
        maven \
&& rm -rf /var/lib/apt/lists/* \
&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
&& add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
        docker-ce docker-ce-cli containerd.io \
&& rm -rf /var/lib/apt/lists/* 

#RUN add-apt-repository ppa:natecarlson/maven3 \
#&& apt-get update \
#&& apt-get install -y --no-install-recommends \
#        maven3 \
#&& rm -rf /var/lib/apt/lists/* \
#&& ln -s /usr/bin/mvn3 /usr/bin/mvn

#RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
#RUN echo "root:123456" | chpasswd

WORKDIR /azp
RUN wget -nv https://vstsagentpackage.azureedge.net/agent/2.153.1/vsts-agent-linux-x64-2.153.1.tar.gz

RUN wget -nv https://downloads.gradle-dn.com/distributions/gradle-6.3-bin.zip && mkdir -p /opt/gradle && unzip -d /opt/gradle gradle-6.3-bin.zip && rm -rf gradle-6.3-bin.zip
ENV PATH="${PATH}:/opt/gradle/gradle-6.3/bin"

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]
