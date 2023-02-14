<p align="center">
  <img height="400" height="400" src="https://raw.githubusercontent.com/meowment/meowment/main/Logo/coreum.jpg">
</p>

## Useful Links
- Website: https://www.coreum.com/
- Twitter: https://twitter.com/CoreumOfficial
- Linkedin: https://www.linkedin.com/company/coreumofficial
- Documentation: https://docs.coreum.dev/

## Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   4|  8GB | 150GB    |

### Auto Installation
```
wget -O core https://raw.githubusercontent.com/meowment/testnet_tutorial/main/coreum/core && chmod +x core && ./core
```

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
cored status 2>&1 | jq .SyncInfo
```
### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
cored keys add $WALLET --keyring-backend test
```

(OPTIONAL) To recover your wallet using seed phrase
```
humansd keys add $WALLET --recover
```

To get current list of wallets
```
cored keys list
```

### Create validator
Before creating validator please make sure that you have at least 1 heart (1 heart is equal to 1000000 uheart) and your node is synchronized

To check your wallet balance:
```
humansd query bank balances core..address
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
cored tx staking create-validator \
  --amount 20000000000utestcore \
  --from wallet \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(cored tendermint show-validator) \
  --moniker meowmentguide \
  --chain-id coreum-testnet-1 \
  --identity="" \
  --details="" \
  --website="" \
  --gas auto \
  --keyring-backend test -y
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu cored -o cat
```

Start service
```
sudo systemctl start cored
```

Stop service
```
sudo systemctl stop cored
```

Restart service
```
sudo systemctl restart cored
```

### Node info
Synchronization info
```
cored status 2>&1 | jq .SyncInfo
```

Validator info
```
cored status 2>&1 | jq .ValidatorInfo
```

Node info
```
cored status 2>&1 | jq .NodeInfo
```

Show node id
```
cored tendermint show-node-id
```

### Wallet operations
List of wallets
```
cored keys list
```

Recover wallet
```
cored keys add $WALLET --recover
```

Delete wallet
```
cored keys delete $WALLET
```

Get wallet balance
```
cored query bank balances core...address
```

Transfer funds
```
cored tx bank send core...address core...address 10000000utestcore --keyring-backend test --chain-id=coreum-testnet-1
```

### Voting
```
cored tx gov vote 1 yes --from $WALLET --keyring-backend test --chain-id=coreum-testnet-1
```

### Staking, Delegation and Rewards
Delegate stake
```
cored tx staking delegate humansvaloperaddres 10000000utestcore --from=$WALLET --keyring-backend test --chain-id=coreum-testnet-1 --gas=auto
```

Redelegate stake from validator to another validator
```
cored tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utestcore --from=$WALLET --keyring-backend test --chain-id=coreum-testnet-1 --gas=auto
```

Withdraw all rewards
```
cored tx distribution withdraw-all-rewards --from=$WALLET --keyring-backend test --chain-id=coreum-testnet-1 --gas=auto
```

Withdraw rewards with commision
```
cored tx distribution withdraw-rewards corevaloperaddres --from=$WALLET --commission --keyring-backend test --chain-id=coreum-testnet-1
```

### Validator management
Edit validator
```
cored tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --from=$WALLET \
  --chain-id=coreum-testnet-1 \
  --gas=auto \
  --keyring-backend test
```

Unjail validator
```
cored tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=coreum-testnet-1 \
  --gas=auto \
  --keyring-backend test
```

### Delete node
This commands will completely remove node from server. Use at your own risk!

```
sudo systemctl stop cored
sudo systemctl disable cored
sudo rm -rf /etc/systemd/system/cored.service
sudo systemctl daemon-reload
sudo rm $(which cored)
sudo rm -rf $HOME/.core
sudo rm -rf $HOME/core
```
