<p align="center">
  <img height="400" height="400" src="https://raw.githubusercontent.com/meowment/meowment/main/Logo/humans.jpg">
</p>

## Useful Links
- Website: https://humans.ai
- Twitter: https://twitter.com/humansdotai
- Resources: https://linktr.ee/humansdotai
- Documentation: https://docs.humans.zone

## Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   4|  8GB | 150GB    |

## Auto installation
```
wget -O hums https://raw.githubusercontent.com/meowment/testnet_tutorial/main/humansai/hums && chmod +x hums && ./hums
```

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
humansd status 2>&1 | jq .SyncInfo
```
### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
humansd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
humansd keys add $WALLET --recover
```

To get current list of wallets
```
humansd keys list
```

### Create validator
Before creating validator please make sure that you have at least 1 heart (1 heart is equal to 1000000 uheart) and your node is synchronized

To check your wallet balance:
```
humansd query bank balances humans..address
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
humansd tx staking create-validator \
  --amount 1000000uheart \
  --from wallet \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(humansd tendermint show-validator) \
  --moniker meowmentguide \
  --chain-id testnet-1 \
  --identity="" \
  --details="" \
  --website="" -y
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu humansd -o cat
```

Start service
```
sudo systemctl humansd seid
```

Stop service
```
sudo systemctl humansd seid
```

Restart service
```
sudo systemctl restart humansd
```

### Node info
Synchronization info
```
humansd status 2>&1 | jq .SyncInfo
```

Validator info
```
humansd status 2>&1 | jq .ValidatorInfo
```

Node info
```
humansd status 2>&1 | jq .NodeInfo
```

Show node id
```
humansd tendermint show-node-id
```

### Wallet operations
List of wallets
```
humansd keys list
```

Recover wallet
```
humansd keys add $WALLET --recover
```

Delete wallet
```
humansd keys delete $WALLET
```

Get wallet balance
```
humansd query bank balances humans...address
```

Transfer funds
```
humansd tx bank send humans...address humans...address 10000000uheart
```

### Voting
```
humansd tx gov vote 1 yes --from $WALLET --chain-id=testnet-1
```

### Staking, Delegation and Rewards
Delegate stake
```
humansd tx staking delegate humansvaloperaddres 10000000uheart --from=$WALLET --chain-id=testnet-1 --gas=auto
```

Redelegate stake from validator to another validator
```
humansd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uheart --from=$WALLET --chain-id=testnet-1 --gas=auto
```

Withdraw all rewards
```
humansd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=testnet-1 --gas=auto
```

Withdraw rewards with commision
```
humansd tx distribution withdraw-rewards humansvaloperaddres --from=$WALLET --commission --chain-id=testnet-1
```

### Validator management
Edit validator
```
humansd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=testnet-1 \
  --from=$WALLET
```

Unjail validator
```
humansd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=testnet-1 \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop humansd && \
sudo systemctl disable humansd && \
rm /etc/systemd/system/humansd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf humans && \
rm -rf .humans && \
rm -rf $(which humansd)
```
