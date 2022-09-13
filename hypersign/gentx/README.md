</p>
<p style="font-size:14px" align="right">
<a href="https://discord.gg/RAnJjbkyzx" target="_blank">Join Hypersign Protocol Discord<img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://github.com/meowment/" target="_blank">More Guide Tutorials<img src="https://avatars.githubusercontent.com/u/65986100?s=96&v=4" width="30"/></a>
</p>


# Setting up a Gentx for upcoming testnet

## Operating System
* Linux (Ubuntu 20.04+ Recommended)
* MacOS

## Hardware Requirements
* Minimum Requirements
    * 4 GB RAM
    * 250 GB SSD
    * 1.4 GHz x2 CPU
* Recommended
    * 8 GB RAM
    * 500 GB SDD
    * 2.0 GHz x4 CPU
## Setting up vars
```
NODENAME=<YOUR MONIKER>
```
Change `<YOUR MONIKER>` To anything you like 

Save and import vars into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export HID_CHAIN_ID=jagrat" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Update Packages
```
sudo apt update && sudo apt upgrade -y
```

## Install Prerequisites
```
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```
## Install GO (One command)
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```
## Download and Build Binaries
```
cd $HOME
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
make install
```
### Check version
It should show ver `v0.1.0`
```
hid-noded version
```
### Make wallet
To create new wallet run :
```
hid-noded keys add wallet
```
DONT FORGET TO SAVE MNEMONICS!

To recover old wallet run:
```
hid-noded keys add wallet --recover
```
copy your Mnemonic
You can view the key address information using the command: `hid-noded keys list`

## Validator Setup (Pre-Genesis)
Init node
```
hid-noded init $NODENAME --chain-id $HID_CHAIN_ID
```
Run the following to change the coin denom from `stake` to `uhid `in the generated `genesis.json`
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom" ]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["ssi"]["chain_namespace"]="jagrat"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```

### Create Gentx Account
Add Genesis account
```
hid-noded add-genesis-account wallet 100000000000uhid
```
Create Gentx 
```
hid-noded gentx wallet 100000000000uhid \
--chain-id $HID_CHAIN_ID \
--moniker="$NODENAME" \
--commission-max-change-rate=0.01 \
--commission-max-rate=1.0 \
--commission-rate=0.07 \
--min-self-delegation=100000000000 \
--details=" " \
--security-contact=" " \
--website=" "
```
You can change `--details , --security-contact , and --website` as you like or leave it empty

Gentx TX will be saved in `/home/$USER/.hid-node/config/gentx/gentx-xxxx.json"`

## Create PR
- Fork the [repository](https://github.com/hypersign-protocol/networks)
- Copy the contents of `${HOME}/.hid-node/config/gentx/gentx-XXXXXXXX.json.` 
- Create a file `gentx-<validator-name-without-spaces>.json` under the `testnet/jagrat/gentxs` folder in the forked repo and paste the copied text from the last step into the file.
- Create a file `peers-<validator-name>.txt` under the `testnet/jagrat/peers` directory in the forked repo.
- Run `hid-noded tendermint show-node-id` and copy the output.
- Run `ifconfig` or `curl ipinfo.io/ip` and copy your IP address.
- Form the complete node address in the format: `<node-id>@<IP ADDRESS>:<p2p-port>`. Example: `31a2699a153e60fcdbed8a47e060c1e1d4751616@<IP ADDRESS>:26656`. Note: The default P2P port is `26656`. If you want to change the port configuration, open `${HOME}/.hid-node/config/config.toml` and under `[p2p]`, change the port in `laddr` attribute.
- Paste the complete node address from the last step into the file `testnet/jagrat/peers/peer-<validator-name-without-spaces>.txt`.
- Create a Pull Request to the main branch of the repository
 
## Wait for Instructions and qualify
To qualify fill the [FORM](https://app.fyre.hypersign.id/form/hidnet-validator-interest?referrer=ZWxhbmcuMjA5QGdtYWlsLmNvbQ==)
