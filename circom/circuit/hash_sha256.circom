pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/sha256/sha256.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template HashSha256(size) {  

   signal input in[size];  
   signal output out;  

   component sha = Sha256(size);
   sha.in <== in;

   component b2n = Bits2Num(256);
   b2n.in <== sha.out;

   out <== b2n.out;
}


component main = HashSha256(16);
