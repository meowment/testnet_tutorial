
# Manta The Manta Network Trusted Setup Is Now Open for Contributions

<p align="center">
  <img style="margin: auto; height: 100px; border-radius: 50%;" src="https://user-images.githubusercontent.com/65535542/204483961-992f1e39-ae50-4c03-b528-ee32a2563640.jpg">
</p>

## Installation and Register

```bash
source ~/.profile
```

```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/Manta-Network/manta-rs/main/tools/install.sh | sh
```

```bash
manta-trusted-setup register
```
<p align="center">
  <img src="[https://user-images.githubusercontent.com/65535542/204483961-992f1e39-ae50-4c03-b528-ee32a2563640.jpg](https://user-images.githubusercontent.com/65535542/204484297-ba3881a3-7af9-40fe-89c4-ba44c0af7119.png
)">
</p>


![manta2](https://user-images.githubusercontent.com/65535542/204484297-ba3881a3-7af9-40fe-89c4-ba44c0af7119.png)

Don't forget to save your secret phrase and filled the form to get rewards

- How to get Calamari address
- Go to https://polkadot.js.org/apps/#/settings/metadata
- Change the chain on drop-down menu on the left side, search Calamari chain then switch
- Go to setting menu then update metadata
- Back to polkadot wallet, click the 3 dots then change to Calamari Parachain chain
- Done

## Run Contributor

```bash
 sudo apt update
```

```bash
sudo apt install pkg-config build-essential libssl-dev curl jq
```

Install Rust

```bash
curl https://sh.rustup.rs/ -sSf | sh -s -- -y
```

## Setting Path
```bash
source $HOME/.cargo/env
```

## Install Manta-RS

```bash
git clone https://github.com/Manta-Network/manta-rs.git
```

## Installation

```bash
screen -S manta
```
```bash
cd manta-rs
```

```bash
cargo run --release --all-features --bin groth16_phase2_client contribute
```

- Input phrase we got after register
- Wait until running
- Done

## Other Command 

Go to Screen
```bash
screen -Rd manta
```

Delete Directory
```bash
rm -rf manta-rs
```


