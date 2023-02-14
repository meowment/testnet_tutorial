## Node setup
Make your moniker name first.
```
export MONIKER={MONIKER}
source ~/.bash_profile
```
### • Automatic Installation •
You can setup your node in few minutes with this script below. Just follow the instructions.\
```
wget -O testnet.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/gameofalliance/testnet.sh && chmod +x testnet.sh
```

### Execute installation with chain
```
./testnet.sh -c ordos-1
```
============================================================================================
### Copy binaries to bin
```
cp ~/go/bin/ordosd /usr/local/bin/
```

### Create wallet
To create new wallet
```
ordosd keys add wallet
```
Change `wallet` to name own your wallet

To recover wallet existing keys with mneomenic 
```
ordosd keys add wallet --recover
```
Change `wallet` to name own your wallet

To see current keys 
```
ordosd keys list
```

### Setting Seeds
```
SEEDS="2c66624a7bbecd94e8be4005d0ece19ce284d7c3@54.196.186.174:41356,6ebf0000ee85ff987f1d9de3223d605745736ca9@35.168.16.221:41356,71f96fe3eec96b9501043613a32a5a306a8f656b@goa-seeds.lavenderfive.com:10656" 
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ordosd/config/config.toml
```

### Setting indexer (Optional)
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.ordosd/config/config.toml
```

### Create systemctl
```
sudo tee /etc/systemd/system/ordosd.service > /dev/null <<EOF
[Unit]
Description=ordosd - Service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ordosd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable ordosd
```
### Create validator
Make sure your node was synced to false status, before create validator

To check if your node is synced simply run
`ordosd status 2>&1 | jq .SyncInfo`

Creating validator with `5000000uord`

```
ordosd tx staking create-validator \
    --amount=5000000uord \
    --pubkey=$(ordosd tendermint show-validator) \
    --moniker=$MONIKER \
    --chain-id=ordos-1 \
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
journalctl -fu ordosd -o cat
```

Start service
```
sudo systemctl start ordosd
```

Stop service
```
sudo systemctl stop ordosd
```

Restart service
```
sudo systemctl restart ordosd
```

### Node info
Synchronization info
```
ordosd status 2>&1 | jq .SyncInfo
```

Validator info
```
ordosd status 2>&1 | jq .ValidatorInfo
```

Node info
```
ordosd status 2>&1 | jq .NodeInfo
```

Show node id
```
ordosd tendermint show-node-id
```

### Wallet operations
List all wallets
```
ordosd keys list
```

Recover your wallet with phrase
```
ordosd keys add wallet --recover
```

Delete your wallet
```
ordosd keys delete wallet
```

Check your wallet balance
```
ordosd query bank balances <address>
```

### Staking, Delegation and Rewards
Delegate stake
```
ordosd tx staking delegate <valoper address> <amount>uord --from=wallet --chain-id=ordos-1 --gas=auto
```

Redelegate stake from validator to another validator
```
ordosd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> <amount>uord --from=wallet --chain-id=ordos-1 --gas=auto
```

Withdraw all rewards
```
ordosd tx distribution withdraw-all-rewards --from=wallet --chain-id=ordos-1 --gas=auto
```

Withdraw rewards with commision
```
ordosd tx distribution withdraw-rewards <valoper address> --from=wallet --chain-id=ordos-1 --gas=auto
```

### Validator management
Edit validator
```
ordosd tx staking edit-validator \
--moniker=$MONIKER 
```
Unjail validator
```
ordosd tx slashing unjail \
  --broadcast-mode=block \
  --from=wallet \
  --chain-id=ordos-1 \
  --gas=auto
```

### Delete node
```
sudo systemctl stop ordosd && \
sudo systemctl disable ordosd && \
rm /etc/systemd/system/ordosd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .ordosd && \
rm -rf $(which ordosd)
```
