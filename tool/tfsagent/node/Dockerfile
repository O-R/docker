From node:15.8.0-alpine3.13

RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache \
        ca-certificates \
        \
        # .NET Core dependencies
        krb5-libs \
        libgcc \
        libintl \
        libssl1.1 \
        libstdc++ \
        lttng-ust \
        tzdata \
        userspace-rcu \
        zlib \
        curl wget\
        git \
&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

WORKDIR /azp
RUN wget -nv https://vstsagentpackage.azureedge.net/agent/2.153.1/vsts-agent-linux-x64-2.153.1.tar.gz

COPY ./start.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/start.sh
ENTRYPOINT ["start.sh"]
