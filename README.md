# BitRewards XBRC Masternode Installer
### Bash installer for XBRC Masternode on Ubuntu 16.04 LTS x64


#### If you just want to run the compiled daemon with all dependencies. Login to your vps as root, download the install_mn.sh file and then run it:
```
wget https://raw.githubusercontent.com/crypt0n1nj4/xbrc_masternode/master/install_mn.sh
bash ./install_mn.sh

```

#### On the client-side, add the following line to masternode.conf: Masternode Private Key should be aligned between the wallet controller and VPS Wallet
```
node-alias vps-ip:28001	node-key collateral-txid vout
```

#### Run the qt wallet, go to Masternode tab, choose your node and click "start alias" at the bottom.

#### Masternode Setup Guide:
```

```
