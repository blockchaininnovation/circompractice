# circom-practice

## セットアップ
circomはビルドしてインストールする．
ここの上のディレクトリにインストールする．
ビルドするためにRustが必要．

https://docs.circom.io/getting-started/installation/

### rustインストール
まずはrustの環境が必要なのでインストール．

```
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

その後PATHを通す．
.bash_profileや.bash_rcに以下を記述．
```
export PATH="$HOME/.cargo/bin:$PATH"
```
sourceすることを忘れずに．


### circomのインストール
ソースからビルドしてインストールする．
```
cd ..
git clone https://github.com/iden3/circom.git
cd circom
cargo build --release
cargo install --path circom
```

### nodejsインストール

#### 1. nvm ( Node Version Manager ) のインストール

- #### Mac

  1. `command` + `space` で Spotlight Search を開き、 `terminal` と入力

  2. 以下のコマンドの **どちらか** を入力し `return`

     ```zsh
     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
     ```

     ```zsh
     wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
     ```

  3. 以下のコマンドを実行し、正常にインストールされているか確認 ( `nvm` と表示されたら OK )

     ```zsh
     command -v nvm
     ```

     - `nvm: command not found` が出る場合、以下のコマンド実行してみてください

       - bash の場合

         ```bash
         source ~/.bash_profile
         ```

       - zsh の場合

         ```zsh
         source ~/.zshrc
         ```

#### 2. Node.js のインストール

- Mac はターミナル、Windows はコマンドプロンプト ( または WSL ) を開いておいてください

1. 以下のコマンドを実行し、`Node.js: 20.14.0` をインストール

   ```cmd
   nvm install 20.14.0
   ```

2. 以下のコマンドを実行し、`Node.js: 20.14.0` を使用しているか確認 ( `v20.14.0` と表示されたら OK )

   ```cmd
   node --version
   ```

   - 違うバージョンが表示される場合、以下のコマンドを実行してください

     ```cmd
     nvm use 20.14.0
     ```

- また以下のコマンドを実行し、`npm` があることも確認してください

  ```cmd
  npm --version
  ```

#### npm -gでsudoを使わないようにする
npm -g (global)でインストールするとPC全体で使用できるようになるので便利．
一方，/usr/local以下にインストールしようとするのでsudoをつけないとダメで，さらにログはホームディレクトリ内に作られるため，それのオーナーがrootになるなどいろいろ不便．

そもそもPC全体で使うことは不要でそのユーザーで使えれば十分．

https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally

.npm-globalディレクトリを作成
```
mkdir ~/.npm-global
```

以下2つを.bashrcに追記．

環境変数で上のディレクトリを指定．
```
export NPM_CONFIG_PREFIX=~/.npm-global
```

PATHの設定
```
export PATH=$NPM_CONFIG_PREFIX/bin:$PATH
```


## 実行手順

### npm install
```
npm install
```

### トラステッドセットアップ，回路生成から証明生成，検証

https://qiita.com/oggata/items/a2c8a4041eac3734f712
を参考．

まずはcircuit.circomを書く．
これはどんな処理を対象とするかを記述．
その中に隠蔽化したい情報が含まれる．


その後circomファイルを回路ファイルに変換．
回路はR1CSの形式で表現される．
```
circom circuit.circom --r1cs --wasm --sym --c
npx snarkjs info -r circuit.r1cs 
```

トラステッドセットアップセレモニー．
まずは回路を指定しない状態で鍵を生成する．
参加者の中で一人でも信用できれば(全員が共謀していない限りは)OK．
```
npx snarkjs powersoftau new bn128 12 POT12_0.ptau -v

npx snarkjs powersoftau contribute POT12_0.ptau POT12_1.ptau --name="aaa" -v -e="some random text"
npx snarkjs powersoftau contribute POT12_1.ptau POT12_2.ptau --name="aaa" -v -e="some random text"
npx snarkjs powersoftau contribute POT12_2.ptau POT12_3.ptau --name="aaa" -v -e="some random text"

npx snarkjs powersoftau verify POT12_3.ptau
```

ランダムビーコンの適用．
一定時間が経過すると利用できないランダム性を持つ情報源．
```
npx snarkjs powersoftau beacon POT12_3.ptau POT12_beacon.ptau 53166ee0 10 -n="beacon"
npx snarkjs powersoftau prepare phase2 POT12_beacon.ptau POT12_final.ptau -v

npx snarkjs powersoftau verify POT12_final.ptau
```

トラステッドセットアップセレモニー（2回目）．
回路を指定した，証明用の鍵と検証用の鍵の2つを生成．
```
npx snarkjs zkey new circuit.r1cs POT12_final.ptau circuit_1.zkey
npx snarkjs zkey contribute circuit_1.zkey  circuit_2.zkey --name="aaa" -v -e="some random text"
npx snarkjs zkey contribute circuit_2.zkey  circuit_3.zkey --name="aaa" -v -e="some random text"

npx snarkjs zkey verify circuit.r1cs POT12_final.ptau circuit_3.zkey
```

ランダムビーコンの適用．
circuit_final.zkeyが証明用の鍵．
```
npx snarkjs zkey beacon circuit_3.zkey circuit_final.zkey 53166ee0 10 -n="final beacon"

npx snarkjs zkey verify circuit.r1cs POT12_final.ptau circuit_final.zkey
```


検証用の鍵verification_key.json生成．
```
npx snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
```

witnessを生成．
回路と，そのインプットをもとにウィットネスを生成する．
```
npx snarkjs wtns calculate circuit_js/circuit.wasm input.json witness.wtns
```

証明を生成．
回路，ウィットネスと証明鍵をもとに証明（proof.json）と公開値（public.json)を生成．
公開値は，この場合はcの値．
```
npx snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
```

検証用の鍵をもって，public.jsonに対して証明proof.jsonが正しいか検証．
```
npx snarkjs groth16 verify verification_key.json public.json proof.json
 ```


### スクリプト実行
1行ずつ実行するのは大変なのでスクリプトにした．
factor内に.circuitとインプットのjsonをおいて以下のように実行する．
この時はhash.circuitとhash.jsonをcircuitディレクトリ内に置いている．

初めて実行するときは実行権限をつける
```
chmod +x *.sh
```

```
./zkkey.sh hash 12
./zkbuild.sh hash
./zkprove.sh hash hash
./zkverify.sh hash
```
