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
&& rm -rf /var/lib/apt/lists/* \
&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
#RUN echo "root:123456" | chpasswd

#RUN echo "199.232.96.133 raw.githubusercontent.com" >> /etc/hosts
WORKDIR /azp
RUN wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
RUN wget -nv https://vstsagentpackage.azureedge.net/agent/2.153.1/vsts-agent-linux-x64-2.153.1.tar.gz

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
