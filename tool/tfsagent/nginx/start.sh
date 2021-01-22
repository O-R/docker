#!/bin/bash
set -e


print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

print_header "0. install nginx..."
rm -rf /data/nginx
mkdir -p /var/log/nginx
mkdir -p /etc/nginx && touch /etc/nginx/3487498_qmyx.aoyuan.com.cn.key && touch /etc/nginx/3487498_qmyx.aoyuan.com.cn.pem && touch /etc/nginx/aoyuansslcrt.crt && touch /etc/nginx/aoyuansslcrt_full.crt && touch /etc/nginx/aoyuansslcrt.rsa
mkdir -p /data/nginx && mkdir -p /data/nginx/conf/test && mkdir -p /data/nginx/conf/prod
mkdir -p /dat/nginx/ssl && touch /dat/nginx/ssl/3487498_qmyx.aoyuan.com.cn.key && touch /dat/nginx/ssl/3487498_qmyx.aoyuan.com.cn.pem && touch /dat/nginx/ssl/aoyuansslcrt.crt && touch /dat/nginx/ssl/aoyuansslcrt_full.crt && touch /dat/nginx/ssl/aoyuansslcrt.rsa
tar -xvf /azp/nginx-1.18.0-compile.tar.gz -C /  & wait $!
chmod -R 777 /data/nginx
chmod -R 777 /etc/nginx
file=/usr/local/bin/nginx
if [ ! -f ${file} ]; then
    ln -s /data/nginx/nginx /usr/local/bin
fi

if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo 1>&2 "error: missing AZP_TOKEN environment variable"
    exit 1
  fi

  AZP_TOKEN_FILE=/azp/.token
  echo -n $AZP_TOKEN > "$AZP_TOKEN_FILE"
fi

unset AZP_TOKEN

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

rm -rf /azp/agent
mkdir /azp/agent
cd /azp/agent

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing Azure Pipelines agent..."

    ./config.sh remove --unattended \
      --auth PAT \
      --token $(cat "$AZP_TOKEN_FILE")
  fi
}


# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE

print_header "1. Determining matching Azure Pipelines agent..."

AZP_AGENT_RESPONSE=$(curl -LsS \
  -u user:$(cat "$AZP_TOKEN_FILE") \
  -H 'Accept:application/json;api-version=3.0-preview' \
  "$AZP_URL/_apis/distributedtask/packages/agent?platform=linux-x64")

if echo "$AZP_AGENT_RESPONSE" | jq . >/dev/null 2>&1; then
  AZP_AGENTPACKAGE_URL=$(echo "$AZP_AGENT_RESPONSE" \
    | jq -r '.value | map([.version.major,.version.minor,.version.patch,.downloadUrl]) | sort | .[length-1] | .[3]')
fi

if [ -z "$AZP_AGENTPACKAGE_URL" -o "$AZP_AGENTPACKAGE_URL" == "null" ]; then
  echo 1>&2 "error: could not determine a matching Azure Pipelines agent - check that account '$AZP_URL' is correct and the token is valid for that account"
  exit 1
fi

print_header "2. Downloading and installing Azure Pipelines agent..."

#curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz & wait $!
tar -xzf /azp/vsts-agent-linux-x64-2.153.1.tar.gz & wait $!

source ./env.sh

print_header "3. Configuring Azure Pipelines agent..."

./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $(cat "$AZP_TOKEN_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-_work}" \
  --replace \
  --acceptTeeEula & wait $!

print_header "4. Running Azure Pipelines agent..."

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
./run.sh & wait $!
