<p align="center">
  <img height="400" height="400" src="https://pbs.twimg.com/profile_images/1574676844451856386/vhK_6xp-_400x400.jpg">
</p>

## Useful Links
- Website: https://nolus.io/
- Twitter: https://twitter.com/NolusProtocol
- Discord: https://discord.com/invite/nolus-protocol

## Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   4|  8GB | 150GB    |

## Auto Installation
```
wget -O nols https://raw.githubusercontent.com/meowment/testnet_tutorial/main/nolus/nols && chmod +x nols && ./nols
```

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
nolusd status 2>&1 | jq .SyncInfo
```

## Use Snapshot
> IF YOU ALREADY USE AUTO INSTALLATION ABOVE, SKIP THIS!
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4

sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data

curl -L https://snap.nolus-testnet.meowment.xyz/nolus/wasm-nolus.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nolus --strip-components 2
curl -L https://snap.nolus-testnet.meowment.xyz/nolus/nolus-snapshot-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json

sudo systemctl restart nolusd && sudo journalctl -fu nolusd -o cat
```
### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
nolusd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
nolusd keys add $WALLET --recover
```

To get current list of wallets
```
nolusd keys list
```

### Create validator
Before creating validator please make sure that you have at least 1nls (1 nls is equal to 1000000unls) and your node is synchronized

To check your wallet balance:
```
nolusd query bank balances core..address
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
nolusd tx staking create-validator \
  --amount 1000000unls \
  --from <walletName> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(nolusd tendermint show-validator) \
  --moniker meowmentguide \
  --chain-id nolus-rila \
  --identity="" \
  --details="" \
  --website="" -y
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu nolusd -o cat
```

Start service
```
sudo systemctl start nolusd
```

Stop service
```
sudo systemctl stop nolusd
```

Restart service
```
sudo systemctl restart nolusd
```

### Node info
Synchronization info
```
nolusd status 2>&1 | jq .SyncInfo
```

Validator info
```
nolusd status 2>&1 | jq .ValidatorInfo
```

Node info
```
nolusd status 2>&1 | jq .NodeInfo
```

Show node id
```
nolusd tendermint show-node-id
```

### Wallet operations
List of wallets
```
nolusd keys list
```

Recover wallet
```
nolusd keys add $WALLET --recover
```

Delete wallet
```
nolusd keys delete $WALLET
```

Get wallet balance
```
nolusd query bank balances nolus...address
```

Transfer funds
```
nolusd tx bank send nolus...address nolus...address 10000000unls --chain-id=nolus-rila
```

### Voting
```
nolusd tx gov vote 1 yes --from $WALLET --chain-id=nolus-rila
```

### Staking, Delegation and Rewards
Delegate stake
```
nolusd tx staking delegate nolusvaloperaddres 10000000unls --from=$WALLET --chain-id=nolus-rila --gas=auto
```

Redelegate stake from validator to another validator
```
nolusd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unls --from=$WALLET --chain-id=nolus-rila --gas=auto
```

Withdraw all rewards
```
nolusd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=nolus-rila --gas=auto
```

Withdraw rewards with commision
```
nolusd tx distribution withdraw-rewards nolusvaloperaddres --from=$WALLET --commission --chain-id=nolus-rila
```

### Validator management
Edit validator
```
nolusd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --from=$WALLET \
  --chain-id=coreum-testnet-1 \
  --gas=auto \
```

Unjail validator
```
nolusd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=coreum-testnet-1 \
  --gas=auto \
```

### Delete node
This commands will completely remove node from server. Use at your own risk!

```
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm -rf /etc/systemd/system/nolusd.service
sudo systemctl daemon-reload
sudo rm $(which nolusd)
sudo rm -rf $HOME/.core
sudo rm -rf $HOME/nolus-core
```

