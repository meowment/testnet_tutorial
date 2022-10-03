
# Node  setup

## 1. Open Port
```
ufw allow 22/tcp && ufw allow 30303/tcp && ufw allow 8545 && ufw enable
```

## 2. Automatic script
```
wget -O wormholes_install.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/wormhole/wormholes_install.sh && chmod +x wormholes_install.sh && ./wormholes_install.sh
```

