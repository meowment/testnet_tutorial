## Node setup
Make your moniker name first.
```
export MONIKER={MONIKER}
source ~/.bash_profile
```
### • Automatic Installation •
You can setup your node in few minutes with this script below. Just follow the instructions.\
```
wget -O harkonnen.sh https://raw.githubusercontent.com/dickydamaraa/Testnet/main/Alliance-Tera/auto.sh && chmod +x harkonnen.sh
```

### Execute installation with chain
```
./harkonnen.sh -c harkonnen-1
```
============================================================================================
### Copy binaries to bin
```
cp ~/go/bin/harkonnend /usr/local/bin/
```

### Create wallet
To create new wallet
```
harkonnend keys add wallet
```
Change `wallet` to name own your wallet

To recover wallet existing keys with mneomenic 
```
harkonnend keys add wallet --recover
```
Change `wallet` to name own your wallet

To see current keys 
```
harkonnend keys list
```

### Setting Seeds
```
SEEDS="eeb02ac1de00fdb83179de62b897b15b27c65a55@54.196.186.174:41156,15e474a5163a3e63d4030c14e6e42cfd6e4d5afc@35.168.16.221:41156,1772a7a48530cc8adc447fdb7b720c064411667b@goa-seeds.lavenderfive.com:11656" 
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.harkonnend/config/config.toml
```

### Setting indexer (Optional)
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.harkonnend/config/config.toml
```

### Create systemctl
```
sudo tee /etc/systemd/system/harkonnend.service > /dev/null <<EOF
[Unit]
Description=harkonnend - Service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which harkonnend) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable harkonnend
```
### Create validator
Make sure your node was synced to false status, before create validator

To check if your node is synced simply run
`harkonnend status 2>&1 | jq .SyncInfo`

Creating validator with `5000000uhar`

```
harkonnend tx staking create-validator \
    --amount=5000000uhar \
    --pubkey=$(harkonnend tendermint show-validator) \
    --moniker=$MONIKER \
    --chain-id=harkonnen-1 \
    --from=wallet \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation="1"
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu harkonnend -o cat
```

Start service
```
sudo systemctl start harkonnend
```

Stop service
```
sudo systemctl stop harkonnend
```

Restart service
```
sudo systemctl restart harkonnend
```

### Node info
Synchronization info
```
harkonnend status 2>&1 | jq .SyncInfo
```

Validator info
```
harkonnend status 2>&1 | jq .ValidatorInfo
```

Node info
```
harkonnend status 2>&1 | jq .NodeInfo
```

Show node id
```
harkonnend tendermint show-node-id
```

### Wallet operations
List all wallets
```
harkonnend keys list
```

Recover your wallet with phrase
```
harkonnend keys add wallet --recover
```

Delete your wallet
```
harkonnend keys delete wallet
```

Check your wallet balance
```
harkonnend query bank balances <address>
```

### Staking, Delegation and Rewards
Delegate stake
```
harkonnend tx staking delegate <valoper address> <amount>uhar --from=wallet --chain-id=harkonnen-1 --gas=auto
```

Redelegate stake from validator to another validator
```
harkonnend tx staking redelegate <srcValidatorAddress> <destValidatorAddress> <amount>uhar --from=wallet --chain-id=harkonnen-1 --gas=auto
```

Withdraw all rewards
```
harkonnend tx distribution withdraw-all-rewards --from=wallet --chain-id=harkonnen-1 --gas=auto
```

Withdraw rewards with commision
```
harkonnend tx distribution withdraw-rewards <valoper address> --from=wallet --chain-id=harkonnen-1 --gas=auto
```

### Validator management
Edit validator
```
harkonnend tx staking edit-validator \
--moniker=$MONIKER 
```
Unjail validator
```
harkonnend tx slashing unjail \
  --broadcast-mode=block \
  --from=wallet \
  --chain-id=harkonnen-1 \
  --gas=auto
```

### Delete node
```
sudo systemctl stop harkonnend && \
sudo systemctl disable harkonnend && \
rm /etc/systemd/system/harkonnend.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .harkonnend && \
rm -rf $(which harkonnend)
```
