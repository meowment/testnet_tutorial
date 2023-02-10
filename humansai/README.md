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

## Manual installation

Update packages and Install dependencies

~~~bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc -y
~~~

Replace your moniker `<YOUR_MONIKER>` without `<>`, save and import variables into system

~~~bash
HUMANS_PORT=17
echo "export HUMANS_WALLET="wallet"" >> $HOME/.bash_profile
echo "export HUMANS_MONIKER="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export HUMANS_CHAIN_ID="testnet-1"" >> $HOME/.bash_profile
echo "export HUMANS_PORT="${HUMANS_PORT}"" >> $HOME/.bash_profile
source $HOME/.bash_profile
~~~

install go

~~~bash
cd $HOME
VER="1.19.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm -rf  "go$VER.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
~~~

Download and build binaries

~~~bash
cd $HOME
rm -rf ~/humans
git clone https://github.com/humansdotai/humans
cd humans
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
mv humansd ~/go/bin/humansd
~~~

Config and init app

~~~bash
humansd config node tcp://localhost:${HUMANS_PORT}657
humansd config chain-id $HUMANS_CHAIN_ID
humansd config keyring-backend test
humansd init $HUMANS_MONIKER --chain-id $HUMANS_CHAIN_ID
~~~

Download genesis and addrbook

~~~bash
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > $HOME/.humans/config/genesis.json
~~~

Set seeds and peers

~~~bash
SEEDS=""
PEERS="852eb15330eeeaf7c38d6ab300c9768f7ee12039@157.245.195.54:26656,1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656,9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656,6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656,eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656,4de8c8acccecc8e0bed4a218c2ef235ab68b5cf2@45.136.40.12:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.humans/config/config.toml
~~~

Set gustom ports in app.toml file

~~~bash
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${HUMANS_PORT}317\"%;
s%^address = \":8080\"%address = \":${HUMANS_PORT}080\"%;
s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${HUMANS_PORT}090\"%; 
s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${HUMANS_PORT}091\"%; 
s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${HUMANS_PORT}545\"%; 
s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${HUMANS_PORT}546\"%" $HOME/.humans/config/app.toml
~~~

Set custom ports in config.toml file

~~~bash
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${HUMANS_PORT}658\"%; 
s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${HUMANS_PORT}657\"%; 
s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${HUMANS_PORT}060\"%;
s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${HUMANS_PORT}656\"%;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${HUMANS_PORT}656\"%;
s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${HUMANS_PORT}660\"%" $HOME/.humans/config/config.toml
~~~

Config pruning

~~~bash
sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.humans/config/app.toml
~~~

Set minimum gas price, enable prometheus and disable indexing

~~~bash
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uheart"/g' $HOME/.humans/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.humans/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.humans/config/config.toml
~~~

Update block time parameters

~~~bash
CONFIG_TOML="$HOME/.humans/config/config.toml"
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML
~~~

Clean old data

```bash
humansd tendermint unsafe-reset-all --home $HOME/.humans --keep-addr-book
```

Create Service file

~~~bash
sudo tee /etc/systemd/system/humansd.service > /dev/null <<EOF
[Unit]
Description=humans
After=network-online.target

[Service]
User=$USER
ExecStart=$(which humansd) start --home $HOME/.humans
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
~~~

Enable and start service

~~~bash
sudo systemctl daemon-reload
sudo systemctl enable humansd
sudo systemctl restart humansd && sudo journalctl -u humansd -f
~~~


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
sudo systemctl stop humansd
sudo systemctl disable humansd
sudo rm -rf /etc/systemd/system/humansd*
sudo systemctl daemon-reload
sudo rm $(which humansd)
sudo rm -rf $HOME/.humans
sudo rm -fr $HOME/humans
```
