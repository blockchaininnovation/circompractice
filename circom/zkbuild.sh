#!/bin/bash

# 作業ディレクトリの作成
WORKDIR=work/$1
mkdir -p $WORKDIR


#回路はR1CSの形式で表現される．
echo "10. Compile the circuit"
circom circuit/$1.circom --r1cs --wasm --sym --c --output $WORKDIR
# echo "11. View information about the circuit"
# npx snarkjs info -r $WORKDIR/$1.r1cs 

# echo "12. Print the constraints"
# npx snarkjs r1cs print $WORKDIR/$1.r1cs $WORKDIR/$1.sym

echo "13. Export r1cs to json"
npx snarkjs r1cs export json $WORKDIR/$1.r1cs $WORKDIR/$1.r1cs.json
# cat $WORKDIR/$1.r1cs.json


#回路を指定した，証明用の鍵と検証用の鍵の2つを生成．
echo "15. Setup"
# Plonk
npx snarkjs plonk setup $WORKDIR/$1.r1cs $WORKDIR/POT12_final.ptau $WORKDIR/circuit_final.zkey

# echo "21. Verify the final zkey"
# npx snarkjs zkey verify $WORKDIR/$1.r1cs $WORKDIR/POT12_final.ptau $WORKDIR/circuit_final.zkey

#検証用の鍵verification_key.json生成．
echo "22. Export the verification key"
npx snarkjs zkey export verificationkey $WORKDIR/circuit_final.zkey $WORKDIR/verification_key.json
