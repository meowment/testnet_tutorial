<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/meowment/.github/main/images/20221003_175653.jpg">
</p>

# Node  setup for Wormhole Testnet

### Note: Use screen first

## 1. Open Port
```
ufw allow 22/tcp && ufw allow 30303/tcp && ufw allow 8545 && ufw enable
```

## 2. Automatic script
```
wget -O wormholes_install.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/wormhole/wormholes_install.sh && chmod +x wormholes_install.sh && ./wormholes_install.sh
```

### Check the node log
```
tail -f /wm/.wormholes/wormholes.log | grep -i '<your address>'
```

## 3. Become Miner
 - Go to https://www.limino.com/
![image](https://raw.githubusercontent.com/meowment/.github/main/images/IMG_20221003_180357.jpg)

![image](https://raw.githubusercontent.com/meowment/.github/main/images/IMG_20221003_180424.jpg) 
 - Done
## Useful Commands
Check node log
```
tail -f /wm/.wormholes/wormholes.log | grep -i '<your address>'
```
Monitor node
```
wget -O monitor.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/wormhole/monitor.sh && chmod +x monitor.sh && ./monitor.sh
```
Stop node
```
docker stop wormholes
```
Uninstall node
```
docker stop wormholes
rm wormholes_install.sh
rm -rf /wm/.wormholes
```
