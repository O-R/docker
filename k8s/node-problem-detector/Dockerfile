FROM registry.k8s.io/node-problem-detector/node-problem-detector:v0.8.15 AS builder

FROM debian:bookworm-slim

# 安装 curl
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl

# 从 builder 镜像复制 NPD 二进制文件
COPY --from=builder /node-problem-detector /node-problem-detector

ENTRYPOINT ["/node-problem-detector"]
