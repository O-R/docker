FROM hub.c.163.com/library/ubuntu:14.04 as builder
WORKDIR /

RUN mkdir -p extensions/downloads
RUN mv -f $(wget -nv https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/1.6.0/sonarqube-community-branch-plugin-1.6.0.jar 2>&1 |cut -d\" -f2) extensions/downloads/

From sonarqube:8.5-community
WORKDIR /opt/sonarqube

COPY --from=builder /extensions/downloads/* extensions/plugins/
COPY --from=builder /extensions/downloads/* lib/common
