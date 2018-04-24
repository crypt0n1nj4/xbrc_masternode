#!/bin/bash
# install_xbrmn.sh
# Installs Social Wallet XBR masternode on Ubuntu 16.04 LTS x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

while true; do
 if [ -d ~/.xbitrewards ]; then
   printf "~/.xbitrewards/ already exists! The installer will delete this folder. Continue anyway?(Y/n)"
   read REPLY
   if [ ${REPLY} == "Y" ]; then
      pID=$(ps -ef | grep bitrewardsd | awk '{print $2}')
      kill ${pID}
      rm -rf ~/.xbitrewards/
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

# Warning that the script will reboot the server
echo "WARNING: This script will reboot the server when it's finished."
printf "Press Ctrl+C to cancel or Enter to continue: "
read IGNORE

cd

# Get a new privatekey by going to console >> debug and typing masternode genkey
printf "XBR MN GenKey: "
read _nodePrivateKey

# The RPC node will only accept connections from your localhost
_rpcUserName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

# Choose a random and secure password for the RPC
_rpcPassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

# Get the IP address of your vps which will be hosting the XBR Masternode
_nodeIpAddress=$(ip route get 1 | awk '{print $NF;exit}')

# Make a new directory for XBR daemon
mkdir ~/.xbitrewards/
touch ~/.xbitrewards/bitrewards.conf

# Change the directory to ~/.xbitrewards
cd ~/.xbitrewards/

# Create the initial bitrewards.conf file
echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=64
txindex=1
masternode=1
externalip=${_nodeIpAddress}:2721
masternodeprivkey=${_nodePrivateKey}
" > bitrewards.conf
cd

# Install bitrewardsd dependencies using apt-get
apt-get update -y
agt-get upgrade -y
apt-get install -y pkg-config
apt-get -y install build-essential autoconf automake libtool libboost-all-dev libgmp-dev libssl-dev libcurl4-openssl-dev git 
add-apt-repository ppa:bitcoin/bitcoin -y
apt-get install libdb4.8-dev libdb4.8++-dev -y
apt-get install libzmq3-dev -y
apt-get -y install libdb++-dev libboost-all-dev libcrypto++-dev libqrencode-dev libminiupnpc-dev libgmp-dev libgmp3-dev autogen
apt-get install libevent-dev -y

# Compile secp256k1
git clone https://github.com/bitcoin-core/secp256k1.git
cd secp256k1
./autogen.sh
./configure
make
make install
ldconfig

cd

# Download the compiled XBR MN LINUX Daemon and CLI
wget https://raw.githubusercontent.com/crypt0n1nj4/xbr_masternode/master/bitrewardsd

# Make the XBR MN LINUX Daemon and CLI executable
chmod +x bitrewardsd

# Create a directory for xbrnode's cronjobs and the anti-ddos script
rm -r xbrnode
mkdir xbrnode

# Change the directory to ~/xbrnode/
cd ~/xbrnode/

# Download the appropriate scripts
wget https://raw.githubusercontent.com/crypt0n1nj4/xbr_masternode/master/makerun.sh
wget https://raw.githubusercontent.com/crypt0n1nj4/xbr_masternode/master/checkdaemon.sh
wget https://raw.githubusercontent.com/crypt0n1nj4/xbr_masternode/master/upgrade.sh
wget https://raw.githubusercontent.com/crypt0n1nj4/xbr_masternode/master/clearlog.sh


# Create a cronjob for making sure bitrewardsd runs after reboot
if ! crontab -l | grep "@reboot ./bitrewardsd -daemon"; then
  (crontab -l ; echo "@reboot ./bitrewardsd -daemon") | crontab -
fi

# Create a cronjob for making sure bitrewardsd is always running
if ! crontab -l | grep "~/xbrnode/makerun.sh"; then
  (crontab -l ; echo "*/5 * * * * ~/xbrnode/makerun.sh") | crontab -
fi

# Create a cronjob for making sure bitrewardsd is always up-to-date
if ! crontab -l | grep "~/xbrnode/upgrade.sh"; then
  (crontab -l ; echo "0 0 */1 * * ~/xbrnode/upgrade.sh") | crontab -
fi

# Create a cronjob for making sure the daemon is never stuck
if ! crontab -l | grep "~/xbrnode/checkdaemon.sh"; then
  (crontab -l ; echo "*/30 * * * * ~/xbrnode/checkdaemon.sh") | crontab -
fi

# Create a cronjob for clearing the log file
if ! crontab -l | grep "~/xbrnode/clearlog.sh"; then
  (crontab -l ; echo "0 0 */2 * * ~/xbrnode/clearlog.sh") | crontab -
fi

# Give execute permission to the cron scripts
chmod 0700 ./makerun.sh
chmod 0700 ./checkdaemon.sh
chmod 0700 ./upgrade.sh
chmod 0700 ./clearlog.sh

# Firewall security measures
apt install ufw -y
ufw disable
ufw allow 2721
ufw allow 22/tcp
ufw limit 22/tcp
ufw logging on
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

# Reboot the server
reboot
