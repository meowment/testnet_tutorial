<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/171904810-664af00a-e78a-4602-b66b-20bfd874fa82.png">
</p>

# defund node setup for testnet — defund-private-3

Official documentation:
>- [Validator setup instructions](https://github.com/defund-labs/testnet/blob/main/defund-private-3/README.md)

## Hardware Requirements
Like any Cosmos-SDK chain, the hardware requirements are pretty modest.

### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

### Recommended Hardware Requirements 
 - 8x CPUs; the faster clock speed the better
 - 64GB RAM
 - 1TB of storage (SSD or NVME)
 - Permanent Internet connection (traffic will be minimal during testnet; 10Mbps will be plenty - for production at least 100Mbps is expected)

## Set up your defund fullnode
### Option 1 (automatic)
You can setup your defund fullnode in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O defund.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/defund/defund.sh && chmod +x defund.sh && ./defund.sh
```

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
defundd status 2>&1 | jq .SyncInfo
```

### Use Snapshot
Install lz4 (if needed)
```
sudo apt update
sudo apt install snapd -y
sudo snap install lz4
```
then
```
sudo systemctl stop defundd
defundd tendermint unsafe-reset-all --home $HOME/.defund --keep-addr-book
curl -L https://snap.nodeist.net/t/defund/defund.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.defund --strip-components 2
sudo systemctl start defundd && journalctl -u defundd -f --no-hostname -o cat
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
defundd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
defundd keys add $WALLET --recover
```

To get current list of wallets
```
defundd keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```
DEFUND_WALLET_ADDRESS=$(defundd keys show $WALLET -a)
DEFUND_VALOPER_ADDRESS=$(defundd keys show $WALLET --bech val -a)
echo 'export DEFUND_WALLET_ADDRESS='${DEFUND_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export DEFUND_VALOPER_ADDRESS='${DEFUND_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
```
N/A
```

### Create validator
Before creating validator please make sure that you have at least 1 fetf (1 fetf is equal to 1000000 ufetf) and your node is synchronized

To check your wallet balance:
```
defundd query bank balances $DEFUND_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
defundd tx staking create-validator \
  --amount 2000000ufetf \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $DEFUND_CHAIN_ID
```

## Security
To protect you keys please make sure you follow basic security rules

### Set up ssh keys for authentication
Good tutorial on how to set up ssh keys for authentication to your server can be found [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Basic Firewall security
Start by checking the status of ufw.
```
sudo ufw status
```

Sets the default to allow outgoing connections, deny all incoming except ssh and 26656. Limit SSH login attempts
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow ${DEFUND_PORT}656,${DEFUND_PORT}660/tcp
sudo ufw enable
```

## Monitoring
To monitor and get alerted about your validator health status you can use my guide on [Set up monitoring and alerting for defund validator](https://github.com/kj89/testnet_manuals/blob/main/defund/monitoring/README.md)

## Calculate synchronization time
This script will help you to estimate how much time it will take to fully synchronize your node\
It measures average blocks per minute that are being synchronized for period of 5 minutes and then gives you results
```
wget -O synctime.py https://raw.githubusercontent.com/kj89/testnet_manuals/main/defund/tools/synctime.py && python3 ./synctime.py
```

### Check your validator key
```
[[ $(defundd q staking validator $DEFUND_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(defundd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```
defundd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Get currently connected peer list with ids
```
curl -sS http://localhost:${DEFUND_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu defundd -o cat
```

Start service
```
sudo systemctl start defundd
```

Stop service
```
sudo systemctl stop defundd
```

Restart service
```
sudo systemctl restart defundd
```

### Node info
Synchronization info
```
defundd status 2>&1 | jq .SyncInfo
```

Validator info
```
defundd status 2>&1 | jq .ValidatorInfo
```

Node info
```
defundd status 2>&1 | jq .NodeInfo
```

Show node id
```
defundd tendermint show-node-id
```

### Wallet operations
List of wallets
```
defundd keys list
```

Recover wallet
```
defundd keys add $WALLET --recover
```

Delete wallet
```
defundd keys delete $WALLET
```

Get wallet balance
```
defundd query bank balances $DEFUND_WALLET_ADDRESS
```

Transfer funds
```
defundd tx bank send $DEFUND_WALLET_ADDRESS <TO_DEFUND_WALLET_ADDRESS> 10000000ufetf
```

### Voting
```
defundd tx gov vote 1 yes --from $WALLET --chain-id=$DEFUND_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
defundd tx staking delegate $DEFUND_VALOPER_ADDRESS 10000000ufetf --from=$WALLET --chain-id=$DEFUND_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
defundd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$WALLET --chain-id=$DEFUND_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
defundd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$DEFUND_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
defundd tx distribution withdraw-rewards $DEFUND_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$DEFUND_CHAIN_ID
```

### Validator management
Edit validator
```
defundd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$DEFUND_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
defundd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$DEFUND_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop defundd
sudo systemctl disable defundd
sudo rm /etc/systemd/system/defund* -rf
sudo rm $(which defundd) -rf
sudo rm $HOME/.defund* -rf
sudo rm $HOME/defund -rf
sed -i '/DEFUND_/d' ~/.bash_profile
```
