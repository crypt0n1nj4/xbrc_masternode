# Social Wallet WIRE Masternode
### Bash installer for WIRE Masternode on Ubuntu 16.04 LTS x64

#### This shell script comes with 4 cronjobs: 
1. Make sure the daemon is always running: `makerun.sh`
2. Make sure the daemon is never stuck: `checkdaemon.sh`
3. Clear the log file every other day: `clearlog.sh`

#### Login to your vps as root, download the install.sh file and then run it:
```
https://raw.githubusercontent.com/crypt0n1nj4/wire_masternode/master/install_wiremn.sh
bash ./install_wiremn.sh
```

#### On the client-side, add the following line to smartnode.conf:
```
node-alias vps-ip:6520	node-key collateral-txid vout
```

#### Run the qt wallet, go to SmartNodes tab, choose your node and click "start alias" at the bottom.

#### You're good to go now. BEE $SMART! https://smartcash.cc
