#!/bin/bash
#Author : Mohanraj G
#Company : ZOHOCORP

# DeviceKey
KEY="$(printenv KEY)"
echo "KEY : $KEY"

# PollerGroupKey
POLLER_GROUP_KEY="$(printenv POLLER_GROUP_KEY)"
echo "POLLER_GROUP_KEY : $POLLER_GROUP_KEY"

HOST="$(printenv HOST)"
echo "HOST : $HOST"

PORT="$(printenv PORT)"
echo "PORT : $PORT"

# Proxy Starts
PROXY="$(printenv PROXY)"
echo "PROXY : $PROXY"
# Proxy Ends


# Download and install On-Premise Poller gent based on DC.
cd /opt
DOWNLOAD_URL=""
SERVER='https://staticdownloads.site24x7.com'

setServerDomain() {
  case "$KEY" in
  eu_*)
    SERVER='https://staticdownloads.site24x7.eu'
    ;;
  cn_*)
    SERVER='https://staticdownloads.site24x7.cn'
    ;;
  in_*)
    SERVER='https://staticdownloads.site24x7.in'
    ;;
  au_*)
    SERVER='https://staticdownloads.site24x7.net.au'
    ;;
  esac
}

setServerDomain

DOWNLOAD_URL="$SERVER/probe/Site24x7OnPremisePoller_64bit.bin"
# Commenting the following lines as binary is already included within the image.
# echo Download Starts

# echo Download URL : $DOWNLOAD_URL

# wget $DOWNLOAD_URL

# echo Download Completed

# Silent Installation
chmod -R 755 Site24x7OnPremisePoller_64bit.bin

echo "Silent installation of OPP starts"

bash ./Site24x7OnPremisePoller_64bit.bin -i silent

echo "Silent installation of OPP completed"




# Changes in conf/install.txt
cd /opt/Site24x7OnPremisePoller/conf

if [ ! ${#KEY} = 0 ]; then
  echo "Updating the DeviceKey"
  DEVICE_KEY="S24X7KEY=${KEY}"
  sed -i -e "s/S24X7KEY=.*/$DEVICE_KEY/g" install.txt
else
  echo "DEVICE_KEY is null"
fi

if [ ! ${#POLLER_GROUP_KEY} = 0 ]; then
  echo "Updating the PollerGroupKey"
  POLLER_GROUP_KEY="S24X7PGKEY=${POLLER_GROUP_KEY}"
  sed -i -e "$ a $POLLER_GROUP_KEY" install.txt
else
  echo "POLLER_GROUP_KEY is null"
fi

if [ ! ${#PROXY} = 0 ]; then
  echo "Updating the proxy details"

  PROXY="PROXY=${PROXY}"
  sed -i -e "s/PROXY=.*/$PROXY/g" install.txt

  PROXY_HOST="$(printenv PROXY_HOST)"
  if [ ! ${#PROXY_HOST} = 0 ]; then
    PROXY_HOST="PROXY_HOST=${PROXY_HOST}"
    echo "$PROXY_HOST"
    sed -i -e "$ a $PROXY_HOST" install.txt
  else
    echo "PROXY_HOST is null"
  fi

  PROXY_PORT="$(printenv PROXY_PORT)"
  if [ ! ${#PROXY_PORT} = 0 ]; then
    PROXY_PORT="PROXY_PORT=${PROXY_PORT}"
    echo "$PROXY_PORT"
    sed -i -e "$ a $PROXY_PORT" install.txt
  else
    echo "PROXY_PORT is null"
  fi

  PROXY_USER="$(printenv PROXY_USER)"
  if [ ! ${#PROXY_USER} = 0 ]; then
    PROXY_USER="PROXY_USER=${PROXY_USER}"
    echo "$PROXY_USER"
    sed -i -e "$ a $PROXY_USER" install.txt
  else
    echo "PROXY_USER is null"
  fi

  PROXY_PASS="$(printenv PROXY_PASS)"
  if [ ! ${#PROXY_PASS} = 0 ]; then
    PROXY_PASS="PROXY_PASS=${PROXY_PASS}"
    echo "$PROXY_PASS"
    sed -i -e "$ a $PROXY_PASS" install.txt
  else
    echo "PROXY_PASS is null"
  fi
else
  echo "PROXY is null"
fi

if [ ! ${#HOST} = 0 ]; then
  echo "#localsetup.properties" | tee -a localsetup.properties
  WMS="wms.prdid=IC"
  HOST="host=${HOST}"
  PORT="port=${PORT}"
  sed -i -e "$ a $WMS" localsetup.properties
  sed -i -e "$ a $HOST" localsetup.properties
  sed -i -e "$ a $PORT" localsetup.properties
else
  echo "HOST is null"
fi

# Restart
echo "Restarting the On-Premise Poller"
cd /opt/Site24x7OnPremisePoller
bash ./StartServer.sh &

# Sleep
while true; do
  sleep 100
done
