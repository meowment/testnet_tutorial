
# Node  setup for Wormhole Testnet

## 1. Open Port
```
ufw allow 22/tcp && ufw allow 30303/tcp && ufw allow 8545 && ufw enable
```

## 2. Automatic script
```
wget -O wormholes_install.sh https://raw.githubusercontent.com/meowment/testnet_tutorial/main/wormhole/wormholes_install.sh && chmod +x wormholes_install.sh && ./wormholes_install.sh
```

## Useful Commands
View Node Connection Status
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"net_peerCount","id":1}' http://127.0.0.1:8545
```
Checkout Blocks
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_blockNumber","id":1}' http://127.0.0.1:8545
```
Check Account Balance
The parameters in params are account and block height, replace the first parameter with the account you want to query
```
curl -X POST -H 'Content-Type:application/json' --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["<youraddress>","pending"],"id":1}' http://127.0.0.1:8545
```
Checkout The version
```
curl -X POST -H "Content-Type:application/json" --data '{"jsonrpc":"2.0","method":"eth_version","id":64}' http://127.0.0.1:8545
```
Monitor Node
If you want to monitor node operation in real time, you can use the monitoring script.
```
#!/bin/bash
function info(){
     cn=0
     while true
     do
             echo "$cn second."
             echo "node $1"
             rs=`curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","id":64}' https://api.wormholestest.com 2>/dev/null`
             blockNumbers=$(parse_json $rs "result")
             echo "Block height of the whole network: $((16#${blockNumbers:2}))"
             rs1=`curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"net_peerCount","id":64}' 127.0.0.1:$1 2>/dev/null`
             count=$(parse_json $rs1 "result")
             echo "Number of node connections: $((16#${count:2}))"
             rs2=`curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","id":64}' 127.0.0.1:$1 2>/dev/null`
             blckNumber=$(parse_json $rs2 "result")
             echo "Block height of the whole network: $((16#${blckNumber:2}))"
             sleep 5
             clear
             let cn+=5
     done
}

function parse_json(){
     echo "${1//\"/}"|sed "s/.*$2:\([^,}]*\).*/\1/"
}

function main(){
     if [[ $# -eq 0 ]];then
             info 8545
     else
             info $1
     fi
}

main "$@"
```
