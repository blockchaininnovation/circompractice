#!/bin/bash

WORKDIR=work/$1

#Ethereum/用solidityファイルを出力
echo "Start exporting solidity"
npx snarkjs zkey export solidityverifier $WORKDIR/circuit_final.zkey $WORKDIR/Verifier.sol

npx snarkjs zkey export soliditycalldata $WORKDIR/public.json $WORKDIR/proof.json