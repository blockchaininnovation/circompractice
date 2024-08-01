## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# ローカルで開発作業
## ローカルブロックチェーン起動
```
anvil
```
これを実行すると開発用のローカルのブロックチェーンが起動する．
サンプル用のアカウント10個が自動的に生成され，コンソールに出力される．
このプロンプトはそのままにし，以下の作業は別のプロンプトを開き作業を行う．


.env.sampleをコピーして.envファイルを生成．

.envファイルを編集：
```
DEPLOYER_PRIV_KEY=
```
のところに，anvil起動時に出てきた秘密鍵の一つを貼り付け．

```
forge build
```

デプロイ．
```
forge script script/Deployment.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --legacy
```
