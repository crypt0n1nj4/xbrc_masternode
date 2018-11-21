#!/bin/bash
# install_mn.sh
# Installs XBR daemon on Ubuntu 16.04 LTS x64


if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

while true; do
 if [ -d ~/.Bitrewards ]; then
   printf "~/.Bitrewards/ already exists! The installer will delete this folder. Continue anyway?(Y/n)"
   read REPLY
   if [ ${REPLY} == "Y" ]; then
      pID=$(ps -ef | grep Bitrewardsd | awk '{print $2}')
      kill ${pID}
      rm -rf ~/.Bitrewards/
      break
   else
      if [ ${REPLY} == "n" ]; then
        exit
      fi
   fi
 else
   break
 fi
done

cd



# The RPC node will only accept connections from your localhost
_rpcUserName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

# Choose a random and secure password for the RPC
_rpcPassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

# Get the IP address of your vps which will be hosting the XBR Masternode
_nodeIpAddress=$(ip route get 1 | awk '{print $NF;exit}')

# Make a new directory for XBR daemon
mkdir ~/.Bitrewards/
touch ~/.Bitrewards/Bitrewards.conf

# Change the directory to ~/.Bitrewards
cd ~/.Bitrewards/

# Create the initial Bitrewards.conf file
echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=512
txindex=1
externalip=${_nodeIpAddress}:24001
" > Bitrewards.conf
cd

# Install Bitrewardsd dependencies using apt-get
apt-get update -y 
apt-get upgrade -y 
apt-get install -y pkg-config
apt-get -y install build-essential autoconf automake libtool libboost-all-dev libgmp-dev libssl-dev libcurl4-openssl-dev git
apt install software-properties-common
add-apt-repository ppa:bitcoin/bitcoin -y
apt-get -y update 
apt-get install libdb4.8-dev libdb4.8++-dev -y
apt-get install libzmq3-dev -y
apt-get -y install libdb++-dev libboost-all-dev libcrypto++-dev libqrencode-dev libminiupnpc-dev libgmp-dev libgmp3-dev autogen
apt-get install libevent-dev -y

# Download the compiled XBR MN LINUX Daemon and CLI
wget https://github.com/BitRewardscoinnew/BitRewards-Core/raw/master/Bitrewardsd

# Make the XBR MN LINUX Daemon and CLI executable
chmod +x Bitrewardsd

# Copy to USR/BIN
cp Bitrewardsd /usr/bin

# Run the daemon
Bitrewardsd -daemon -txindex


# Create a cronjob for making sure Bitrewardsd runs after reboot
if ! crontab -l | grep "@reboot Bitrewardsd -daemon -txindex"; then
  (crontab -l ; echo "@reboot Bitrewardsd -daemon -txindex") | crontab -
fi

