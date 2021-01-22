From ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive

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
        openjdk-8-jdk \
        nodejs \
        tzdata wget curl \
        maven3 \
&& rm -rf /var/lib/apt/lists/* \
&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
#RUN echo "root:123456" | chpasswd

WORKDIR /azp
RUN wget -nv https://vstsagentpackage.azureedge.net/agent/2.153.1/vsts-agent-linux-x64-2.153.1.tar.gz
COPY ./nginx-1.18.0-compile.tar.gz .

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]
