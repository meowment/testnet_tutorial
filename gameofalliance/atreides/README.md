## Node setup
Make your moniker name first.
```
export MONIKER={MONIKER}
source ~/.bash_profile
```
### • Automatic Installation •
You can setup your node in few minutes with this script below. Just follow the instructions.\
```
wget -O atreides.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/gameofalliance/testnet.sh && chmod +x atreides.sh
```

### Execute installation with chain
```
./atreides.sh -c atreides-1
```
============================================================================================
### Copy binaries to bin
```
cp ~/go/bin/atreidesd /usr/local/bin/
```

### Create wallet
To create new wallet
```
atreidesd keys add wallet
```
Change `wallet` to name own your wallet

To recover wallet existing keys with mneomenic 
```
atreidesd keys add wallet --recover
```
Change `wallet` to name own your wallet

To see current keys 
```
atreidesd keys list
```

### Setting Seeds
```
SEEDS="eeb02ac1de00fdb83179de62b897b15b27c65a55@54.196.186.174:41156,15e474a5163a3e63d4030c14e6e42cfd6e4d5afc@35.168.16.221:41156,1772a7a48530cc8adc447fdb7b720c064411667b@goa-seeds.lavenderfive.com:11656" 
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.atreidesd/config/config.toml
```

### Setting indexer (Optional)
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.atreidesd/config/config.toml
```

### Create systemctl
```
sudo tee /etc/systemd/system/atreidesd.service > /dev/null <<EOF
[Unit]
Description=atreidesd - Service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which atreidesd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable atreidesd
```
### Create validator
Make sure your node was synced to false status, before create validator

To check if your node is synced simply run
`atreidesd status 2>&1 | jq .SyncInfo`

Creating validator with `5000000uatr`

```
atreidesd tx staking create-validator \
    --amount=5000000uatr \
    --pubkey=$(atreidesd tendermint show-validator) \
    --moniker=$MONIKER \
    --chain-id=atreides-1 \
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
journalctl -fu atreidesd -o cat
```

Start service
```
sudo systemctl start atreidesd
```

Stop service
```
sudo systemctl stop atreidesd
```

Restart service
```
sudo systemctl restart atreidesd
```

### Node info
Synchronization info
```
atreidesd status 2>&1 | jq .SyncInfo
```

Validator info
```
atreidesd status 2>&1 | jq .ValidatorInfo
```

Node info
```
atreidesd status 2>&1 | jq .NodeInfo
```

Show node id
```
atreidesd tendermint show-node-id
```

### Wallet operations
List all wallets
```
atreidesd keys list
```

Recover your wallet with phrase
```
atreidesd keys add wallet --recover
```

Delete your wallet
```
atreidesd keys delete wallet
```

Check your wallet balance
```
atreidesd query bank balances <address>
```

### Staking, Delegation and Rewards
Delegate stake
```
atreidesd tx staking delegate <valoper address> <amount>uatr --from=wallet --chain-id=atreides-1 --gas=auto
```

Redelegate stake from validator to another validator
```
atreidesd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> <amount>uatr --from=wallet --chain-id=atreides-1 --gas=auto
```

Withdraw all rewards
```
atreidesd tx distribution withdraw-all-rewards --from=wallet --chain-id=atreides-1 --gas=auto
```

Withdraw rewards with commision
```
atreidesd tx distribution withdraw-rewards <valoper address> --from=wallet --chain-id=atreides-1 --gas=auto
```

### Validator management
Edit validator
```
atreidesd tx staking edit-validator \
--moniker=$MONIKER 
```
Unjail validator
```
atreidesd tx slashing unjail \
  --broadcast-mode=block \
  --from=wallet \
  --chain-id=atreides-1 \
  --gas=auto
```

### Delete node
```
sudo systemctl stop atreidesd && \
sudo systemctl disable atreidesd && \
rm /etc/systemd/system/atreidesd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .atreidesd && \
rm -rf $(which atreidesd)
```
