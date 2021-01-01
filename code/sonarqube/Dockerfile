FROM ubuntu:14.04 as builder
WORKDIR /
RUN apt-get update \
    && apt-get install -y wget \ 
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p extensions/downloads && mkdir -p extensions/lib
RUN mv -f $(wget -nv https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/1.6.0/sonarqube-community-branch-plugin-1.6.0.jar 2>&1 |cut -d\" -f2) extensions/downloads/ \
&& cp extensions/downloads/* extensions/lib/ \
&& mv -f $(wget -nv https://github.com/xuhuisheng/sonar-l10n-zh/releases/download/sonar-l10n-zh-plugin-8.5/sonar-l10n-zh-plugin-8.5.jar 2>&1 |cut -d\" -f2) extensions/downloads/


From sonarqube:8.5-community
WORKDIR /opt/sonarqube
RUN mkdir -p extensions/plugins

COPY --from=builder /extensions/downloads/* extensions/plugins/
COPY --from=builder /extensions/lib/* lib/common/
