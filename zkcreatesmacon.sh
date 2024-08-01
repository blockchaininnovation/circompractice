#!/bin/bash

WORKDIR=work/$1

#Ethereum/用solidityファイルを出力
npx snarkjs zkey export solidityverifier $WORKDIR/circuit_final.zkey $WORKDIR/Verifier.sol

npx snarkjs zkey export soliditycalldata $WORKDIR/public.json $WORKDIR/proof.json