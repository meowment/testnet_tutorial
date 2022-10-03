<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/meowment/tes/main/20221003_175653.jpg?token=GHSAT0AAAAAABVY4L2KINRLOMB5GAVUSYBMYZ2YDPA">
</p>

# Node  setup for Wormhole Testnet

## 1. Open Port
```
ufw allow 22/tcp && ufw allow 30303/tcp && ufw allow 8545 && ufw enable
```

## 2. Automatic script
```
wget -O wormholes_install.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/wormhole/wormholes_install.sh && chmod +x wormholes_install.sh && ./wormholes_install.sh
```
## 3. Become Miner
 - Go to https://www.limino.com/
 - 
![image](https://raw.githubusercontent.com/meowment/tes/main/IMG_20221003_180357.jpg?token=GHSAT0AAAAAABVY4L2KSR4QC35TYVI2RHKGYZ2YKBA)

![image](https://raw.githubusercontent.com/meowment/tes/main/IMG_20221003_180424.jpg?token=GHSAT0AAAAAABVY4L2LFTG63TXLST7IH7ROYZ2YKIA) 

## Useful Commands
Check node log
```
tail -f /wm/.wormholes/wormholes.log | grep -i '<your address>'
```
Stop node
```
docker stop wormholes
```
