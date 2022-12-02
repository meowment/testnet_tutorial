<p style="font-size:14px" align="right">
<a href="https://t.me/bangpateng_group" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://bangpateng.com/" target="_blank">Visit our website <img src="https://user-images.githubusercontent.com/38981255/184068977-2d456b1a-9b50-4b75-a0a7-4909a7c78991.png" width="30"/></a>
</p>

<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/38981255/185550018-bf5220fa-7858-4353-905c-9bbd5b256c30.jpg">
</p>

## Specification VPS

CPU : 4 or more physical CPU cores
RAM : 32 GB
Storage : 500GB SSD
Connection : 100 Mbps
OS : Ubuntu 18.04 +

# #Point Network Testnet Incentivized

## Instal Otomatis
```
wget -qO point.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/point/point.sh && chmod +x point.sh && ./point.sh
```

## Check Log

```
sudo journalctl -u evmosd -f -o cat
```

## Buat dompet

Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini Masukan Pharse Metamask Kalian dan Jangan lupa simpan mnemonicnya Validator

```
evmosd keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed

```
evmosd keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini

```
evmosd keys list
```

## Save Info Wallet

```
EVMOS_WALLET_ADDRESS=$(evmosd keys show $WALLET -a)
```
Masukan Pharse Wallet
```
EVMOS_VALOPER_ADDRESS=$(evmosd keys show $WALLET --bech val -a)
```
Masukan Pharse Wallet
```
echo 'export EVMOS_WALLET_ADDRESS='${EVMOS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export EVMOS_VALOPER_ADDRESS='${EVMOS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Minta Faucet Menggunakan Address Metamask (Kalo Udah Sekip)

- Isi Form : https://pointnetwork.io/testnet-form (Tunggu 24 Jam Akan Dapat Email dan Coin Test Masuk ke Metamask)
- Add RPC di Metamask (Untuk Memastikan Udah Ada Faucet Landing)

```
Network Title: Point XNet Triton
RPC URL: https://xnet-triton-1.point.space/
Chain ID: 10721
SYMBOL: XPOINT
```

## Cara Convert Token

Note : Jika Saldo faucet Yang kalian Punya Berbeda Address atau Ada di Wallet Metamask Yang Berbeda.
Intinya, Untuk Kalian Yang Claim Token Faucet Pakai Wallet Pertama Metamask dan Wallet Validator itu Berbeda..

## Export Private Key Validator kalian Dengan Perintah

```
evmosd keys unsafe-export-eth-key $WALLET --keyring-backend file
```

- Masukan Pharse atau Password Keyring (Sesuai Yang kalian Bikin Saat Buat Wallet)
- Salin Private Key nya
- Import ke Metamask
- Pindahkan dan Kirim Token XPOINT Yang ada di Address Pertama ke Address `0x..` Yang Baru kalian Import Tadi

## Convert XPOINT

- Buka Situs : https://evmos.me/utils/tools
- Connect Wallet
- Masukan Address `0x..` Metamaskan kalian di Addres Conventer anda Akan Melihat Address `Evmosxxxx` dan Pastikan Sama Dengan Address Wallet Validator Kalian
- Silahkan Check Ke Vps kalian dengan Perintah `evmosd query bank balances address-evmos-kalian`
- Maka Tara Saldo Anda Sudah Ada

## Buat Validator (Pastikan Status False Dan Saldo Udah Ada)

### Check Status (Jika Sudah False dan Token Sudah Landing baru Buat Validator)

```
evmosd status 2>&1 | jq .SyncInfo
```

### Check Saldo 

```
evmosd query bank balances $EVMOS_WALLET_ADDRESS
```
Jika Command di atas Error `$EVMOS_WALLET_ADDRESS` menjadi `Address Kalian`

## Create Validator Nya

```
evmosd tx staking create-validator \
--amount=100000000000000000000apoint \
--pubkey=$(evmosd tendermint show-validator) \
--moniker="MASUKAN-NAMA-VALIDATOR" \
--chain-id=point_10721-1 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="100000000000000000000" \
--gas="400000" \
--gas-prices="0.025apoint" \
--from=MASUKAN-ADDRESS-EVMOS \
--keyring-backend file
```

**Penting :** Jika Output Yang keluar `code:32` atau `code:19` Artinya Error, kalian Bisa Restart Node Dengan Perintah `sudo systemctl restart evmosd && sudo journalctl -u evmosd -f -o cat` Ulangi ULang Buat Validato, Jika tx Sudah `code:0` Next Step

Salin Txhash Nya Lalu Jalankan
```
evmosd query tx PASTE-TX-HASH-DI-SINI
```
Anda Akan Melihat Output Transaksi Anda Berhasil

## Set Validator
```
evmosd tendermint show-validator
evmosd query tendermint-validator-set | grep "$(evmosd tendermint show-address)"
evmosd query slashing signing-info $(evmosd tendermint show-validator)
```
Pastikan 3 Perintah di atas Mengeluarkan Ouput/Balasan

## Edit Validator (Optional Bisa di Sekip)

```
evmosd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$EVMOS_CHAIN_ID \
  --from=$WALLET
  ```

## Claim Reward Hasil Validator

```
evmosd tx distribution withdraw-rewards VALOPER_ADDRESS-KALIAN --from=$WALLET --commission --chain-id=$EVMOS_CHAIN_ID
```
```
evmosd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$EVMOS_CHAIN_ID --gas=auto
```

## Delete Node (Permanent)

```
sudo systemctl stop evmosd
sudo systemctl disable evmosd
sudo rm /etc/systemd/system/evmos* -rf
sudo rm $(which evmosd) -rf
sudo rm $HOME/.evmosd -rf
sudo rm $HOME/point-chain -rf
```
