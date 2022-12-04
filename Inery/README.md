
# INERY TESTNET
<p style="font-size:14px" align="left">


## Hardware Requirement
Minimum
- Memory: 8 GB RAM
- CPU: 4 Core
- Disk: 250 GB SSD Storage
- Bandwidth: 1 Gbps buat Download/100 Mbps for Upload

## Software Requirement

Minimum

| OS |  Ubuntu 18.04 or Ubuntu 20.04  (don't use ubuntu 22.04 because of an error when installing clang 7) |

## Update Package
```bash
  sudo apt-get update && sudo apt install git && sudo apt install screen
```

## Edit Firewall Port
```
ufw allow 22 && ufw allow 8888 && ufw allow 9010 && ufw enable
```

# Installing Node
## Cloning Inery Node from github
```
git clone https://github.com/inery-blockchain/inery-node
```

## Go to inery setup folder
```
cd inery-node/inery.setup
```

## change app permission
```
chmod +x ine.py
```

## export path to local os environment for inery binaries
```
./ine.py --export
```

## refresh path variable
```
cd; source .bashrc; cd -
```

## Edit the configuration
```
sudo nano tools/config.json
```

``` "MASTER_ACCOUNT":
{
    "NAME": "AccountName",
    "PUBLIC_KEY": "PublicKey",
    "PRIVATE_KEY": "PrivateKey",
    "PEER_ADDRESS": "IP:9010",
    "HTTP_ADDRESS": "0.0.0.0:8888",
    "HOST_ADDRESS": "0.0.0.0:9010"
}
```
<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/38981255/184290164-85371bac-f97a-4f8d-8cf8-63e5b5297f83.PNG">
</p>

IP di PEER_ADDRESS ganti pake IP Private kalo yang pake azure kalau yang pake cantabo masukin IP Public , vps ionos juga bisa masukin ip host kalian

## Screen Master Node
```
screen -S master
```

```
./ine.py --master
```

go to inery blockchain folder
```
cd inery-node/inery.setup/master.node/blockchain
```
```
tail -f nodine.log
```

a. Cek block sekarang

```
curl -sSL -X POST 'http://bis.blockchain-servers.world:8888/v1/chain/get_info' -H 'Accept: application/json' | jq -r '.head_block_num'
```

b. Cek block di nodesendiri
``` 
curl -sSL -X POST 'http://localhost:8888/v1/chain/get_info' -H 'Accept: application/json' | jq -r '.head_block_num'
```

1. Stop and clean data blockchain inery
```
cd $HOME/inery-node/inery.setup/master.node/
./stop.sh
pkill nodine
./clean.sh
```

3. Start again
```
./start.sh
```

4. Cek log
```
tail -f nodine.log
```


##
KALO UDAH SYNC BLOCK NYA BISA LANJUT KE STEP WALLET


## Create Wallet

```
cd;  cline wallet create --file defaultWallet.txt
```

## If your wallet has password, you need to unlock it first
```
cline wallet unlock --password YOUR_WALLET_PASSWORD
```

## Import Key
```
cline wallet import --private-key MASTER_PRIVATE_KEY
 ```
 change MASTER_PRIVATE_KEY dengan private kalian
 
 ## Register as producer by executing command
```
cline system regproducer ACCOUNT_NAME ACCOUNT_PUBLIC_KEY 0.0.0.0:9010
```

## Approve your account as producer by executing command
```
cline system makeprod approve ACCOUNT_NAME ACCOUNT_NAME
```

Cek Node kalian di sini - > https://explorer.inery.io/

# Tambahan
### Buat hapus node (uninstall) go to 
```
cd inery.setup/inery.node/ and execute ./stop.sh script
```

### Untuk melanjutkan protokol blockchain, jalankan 
```
start.sh script
```

### Untuk menghapus blockchain dengan semua data dari mesin lokal, buka 
```
cd inery.setup/inery.node/ and execute ./clean.sh script
```

### Kalau Node pas running node masternya ga jalan

```
pkill nodine
```

Lanjut Hapus dulu driectory master-node

```
cd inery-testnet/inery.setup
```

Hapus Directory

```
rm -rf master.node
```
## 
thanks to bang jambulmerah snapshotnya https://jambulmerah.dev/
##
thanks to nodeX capital https://nodex.codes/
##
thanks to bangpateng https://github.com/bangpateng/
##
thanks to dexa airdrop sultan https://github.com/nadi555

