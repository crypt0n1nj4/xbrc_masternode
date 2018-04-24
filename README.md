# Social BitRewards XBR Masternode
### Bash installer for XBR Masternode on Ubuntu 16.04 LTS x64

#### This shell script comes with 4 cronjobs: 
1. Make sure the daemon is always running: `makerun.sh`
2. Make sure the daemon is never stuck: `checkdaemon.sh`
3. Make sure WIRE daemon is always up-to-date: `upgrade.sh`
4. Clear the log file every other day: `clearlog.sh`

#### Login to your vps as root, download the install_xbrmn.sh file and then run it:
```
wget https://raw.githubusercontent.com/crypt0n1nj4/wire_masternode/master/install_xbrmn.sh
bash ./install_xbrmn.sh
```

#### On the client-side, add the following line to masternode.conf: Masternode Private Key should be aligned between the wallet controller and VPS Wallet
```
node-alias vps-ip:6520	node-key collateral-txid vout
```

#### Run the qt wallet, go to Masternode tab, choose your node and click "start alias" at the bottom.

#### Masternode Setup Guide:
```

```
