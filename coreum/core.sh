#!/bin/bash

GREEN="\e[32m"
LIGHT_GREEN="\e[92m"
YELLOW="\e[33m"
DEFAULT="\e[39m"

function install_node {
echo "*********************"
echo -e "\e[1m\e[35m		Lets's begin\e[0m"
echo "*********************"
echo -e "\e[1m\e[32m	Enter your Validator_Name:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read Validator_Name
echo "_|-_|-_|-_|-_|-_|-_|"
echo export Validator_Name=${Validator_Name} >> $HOME/.bash_profile
echo export CHAIN_ID="coreum-testnet-1" >> $HOME/.bash_profile
source ~/.bash_profile

echo -e "\e[1m\e[32m1. Updating packages and dependencies--> \e[0m" && sleep 1
#UPDATE APT
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

echo -e "        \e[1m\e[32m2. Installing GO--> \e[0m" && sleep 1
#INSTALL GO
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version

echo -e "              \e[1m\e[32m3. Downloading and building binaries--> \e[0m" && sleep 1
#INSTALL
cd $HOME
curl -LOf https://github.com/CoreumFoundation/coreum/releases/download/v0.1.1/cored-linux-amd64
chmod +x cored-linux-amd64
mv cored-linux-amd64 $HOME/go/bin/cored

cored init $Validator_Name --chain-id $CHAIN_ID



echo -e "                     \e[1m\e[32m4. Node optimization and improvement--> \e[0m" && sleep 1

SEEDS=""
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utestcore\"/;" ~/.core/coreum-testnet-1/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.core/coreum-testnet-1/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.core/coreum-testnet-1/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.core/coreum-testnet-1/config/config.toml




# pruning and indexer
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.core/coreum-testnet-1/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.core/coreum-testnet-1/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.core/coreum-testnet-1/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.core/coreum-testnet-1/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.core/coreum-testnet-1/config/config.toml


sudo tee /etc/systemd/system/cored.service > /dev/null <<EOF
[Unit]
Description=cored
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cored) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


# start service
sudo systemctl daemon-reload
sudo systemctl enable cored
sudo systemctl restart cored

echo '=============== SETUP FINISHED ==================='
echo -e 'Congratulations:        \e[1m\e[32mSUCCESSFUL NODE INSTALLATION\e[0m'
echo -e 'To check logs:        \e[1m\e[33mjournalctl -u cored -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[35mcurl -s localhost:26657/status\e[0m"

}

function check_logs {

    sudo journalctl -fu cored -o cat
}

function create_wallet {
    echo "Creating your wallet.."
    sleep 2
    
    cored keys add wallet --keyring-backend test
    
    sleep 3
    echo "SAVE YOUR MNEMONIC!!!"


}

function state_sync {
    echo "SOON"
}

function sync_snapshot {
   echo " If you have state sync enabled please turn it off first"
   sleep 3
   sudo apt update
   sudo apt install snapd -y
   sudo snap install lz4
   
   sudo systemctl stop marsd
	cp $HOME/.mars/data/priv_validator_state.json $HOME/.mars/priv_validator_state.json.backup
	rm -rf $HOME/.mars/data

	curl -L https://snapshot.mars.indonode.net/mars-snapshot-2023-01-14.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.mars
	mv $HOME/.mars/priv_validator_state.json.backup $HOME/.mars/data/priv_validator_state.json

	sudo systemctl restart marsd && journalctl -u marsd -f --no-hostname -o cat

}

function delete_node {
echo "BACKUP YOUR NODE!!!"
echo "Deleting node in 3 seconds"
sleep 3
cd $HOME
sudo systemctl stop cored && \
sudo systemctl disable cored && \
rm /etc/systemd/system/cored.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .core && \
rm -rf $(which cored)
echo "Node has been deleted from your machine :)"
sleep 3
}

function select_option {
    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

function print_logo {
    echo -e $LIGHT_GREEN
    echo "   ██████   ███████████████   ███████  █████   ███   ██████████   █████████████████████   ███████████████   ";
    echo "  ░░██████ █████░░███░░░░░█ ███░░░░░██░░███   ░███  ░░██░░██████ █████░░███░░░░░░░██████ ░░██░█░░░███░░░█   ";
    echo "   ░███░█████░███░███  █ ░ ███     ░░██░███   ░███   ░███░███░█████░███░███  █ ░ ░███░███ ░██░   ░███  ░    ";
    echo "   ░███░░███ ░███░██████  ░███      ░██░███   ░███   ░███░███░░███ ░███░██████   ░███░░███░███   ░███       ";
    echo "   ░███ ░░░  ░███░███░░█  ░███      ░██░░███  █████  ███ ░███ ░░░  ░███░███░░█   ░███ ░░██████   ░███       ";
    echo "   ░███      ░███░███ ░   ░░███     ███ ░░░█████░█████░  ░███      ░███░███ ░   █░███  ░░█████   ░███       ";
    echo "   █████     ██████████████░░░███████░    ░░███ ░░███    █████     ███████████████████  ░░█████  █████      ";
    echo "  ░░░░░     ░░░░░░░░░░░░░░   ░░░░░░░       ░░░   ░░░    ░░░░░     ░░░░░░░░░░░░░░░░░░░    ░░░░░  ░░░░░       ";
    echo "                                                                                                            ";
    echo -e $DEFAULT
}
    echo "  ___ ___    ___  __ __      __ ___ ___   ___ ___  | |_   ";
function main {
    cd $HOME

    print_logo

    echo "Meowment Node Installer CLI"
    echo "Choose the command you want to use:"

    options=(
        "🚀 Install Node"
        "📝 Check Logs"
        "🔑 Create wallet"
        "🖧 Sync Via State-sync "
        "🔎 Sync Via Snapshot"
        "🗑️ Delete Node"
        "🎯 Exit"
    )

    select_option "${options[@]}"
    choice=$?
    clear

    case $choice in
        0)
            install_node
            ;;
        1)
            check_logs
            ;;
        2)
            create_wallet
            ;;    
        3)
            state_sync
            ;;
        4)
            sync_snapshot
            ;;
        5)
            delete_node
            ;;    
        6)
            exit 0
            ;;
    esac

    echo -e $DEFAULT
}

main