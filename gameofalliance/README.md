# DISCLAIMER
PLEASE, READ IT CAREFULLY, YOU NEED TO CHANGE IT WITH MANUAL. DONT JUST COPY & PASTE. READ IT CAREFULLY AND EXECUTE WITH FULL MIND & LOGIC.

CHOOSE FOLDER CHAIN TO RUN VALIDATOR. PICK ONE OR IF YOU WANT TO RUN ALL CHAIN, UP TO YOU.

# Alliance node setup testnet
Official documentation:
- Faucet : https://game-of-alliance.terra.money/faucet
- Explorer: -
- Github: https://github.com/terra-money/alliance/
- Discord: https://discord.gg/terra-money
- Docs alliance terra : https://alliance.terra.money/

## Hardware requirements
Same with any cosmos-SDK chain, check this out!

Minimum Hardware Requirements : \
• Ubuntu 22.04 \
• 4 CPU \
• 8gb ram \
• 200GB SSD NVME \
• Permanent Internet connection (traffic will be minimal during run node; 10Mbps will be plenty - for production at least 100Mbps is expected) \
• Open port 26656

**Thats requirements if you want run with local device, but my advice it will great if you rent a VPS and your server will online 24x7**



### Create wallet
To create new wallet
```
{EXECUTABLE} keys add wallet
```
Change `wallet` to name own your wallet

To recover wallet existing keys with mneomenic 
```
{EXECUTABLE} keys add wallet --recover
```
Change `wallet` to name own your wallet

To see current keys 
```
{EXECUTABLE} keys list
```
### Create systemctl
```
sudo tee /etc/systemd/system/{EXECUTABLE}.service > /dev/null <<EOF
[Unit]
Description={EXECUTABLE} - Service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which {EXECUTABLE}) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable {EXECUTABLE}
```
### Create validator
Make sure your node was synced to false status, before create validator

To check if your node is synced simply run
`{EXECUTABLE} status 2>&1 | jq .SyncInfo`

Creating validator with `5000000 {DENOM}`

```
{EXECUTABLE} tx staking create-validator \
    --amount=5000000 {DENOM} \
    --pubkey=$({EXECUTABLE} tendermint show-validator) \
    --moniker={MONIKER} \
    --chain-id={CHAIN-ID} \
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
journalctl -fu {EXECUTABLE} -o cat
```

Start service
```
sudo systemctl start {EXECUTABLE}
```

Stop service
```
sudo systemctl stop {EXECUTABLE}
```

Restart service
```
sudo systemctl restart {EXECUTABLE}
```

### Node info
Synchronization info
```
{EXECUTABLE} status 2>&1 | jq .SyncInfo
```

Validator info
```
{EXECUTABLE} status 2>&1 | jq .ValidatorInfo
```

Node info
```
{EXECUTABLE} status 2>&1 | jq .NodeInfo
```

Show node id
```
{EXECUTABLE} tendermint show-node-id
```

### Wallet operations
List all wallets
```
{EXECUTABLE} keys list
```

Recover your wallet with phrase
```
{EXECUTABLE} keys add wallet --recover
```

Delete your wallet
```
{EXECUTABLE} keys delete wallet
```

Check your wallet balance
```
{EXECUTABLE} query bank balances <address>
```

### Staking, Delegation and Rewards
Delegate stake
```
{EXECUTABLE} tx staking delegate <valoper address> <amount>{DENOM} --from=wallet --chain-id={CHAIN_ID} --gas=auto
```

Redelegate stake from validator to another validator
```
{EXECUTABLE} tx staking redelegate <srcValidatorAddress> <destValidatorAddress> <amount>{DENOM} --from=wallet --chain-id={CHAIN_ID} --gas=auto
```

Withdraw all rewards
```
{EXECUTABLE} tx distribution withdraw-all-rewards --from=wallet --chain-id={CHAIN_ID} --gas=auto
```

Withdraw rewards with commision
```
{EXECUTABLE} tx distribution withdraw-rewards <valoper address> --from=wallet --chain-id={CHAIN_ID} --gas=auto
```

### Validator management
Edit validator
```
{EXECUTABLE} tx staking edit-validator \
  --moniker=$MONIKER \
```
Unjail validator
```
{EXECUTABLE} tx slashing unjail \
  --broadcast-mode=block \
  --from=wallet \
  --chain-id={CHAIN-ID} \
  --gas=auto
```

### Delete node
```
sudo systemctl stop {EXECUTABLE} && \
sudo systemctl disable {EXECUTABLE} && \
rm /etc/systemd/system/{EXECUTABLE}.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .{EXECUTABLE} && \
rm -rf $(which {EXECUTABLE})
```
