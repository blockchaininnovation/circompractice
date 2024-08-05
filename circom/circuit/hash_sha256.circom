pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/sha256/sha256.circom";

template HashSha256(size) {  

   signal input in[size];  
   signal output out[256];  

   component sha = Sha256(size);
   sha.in <== in;

   out <== sha.out;
}

component main = HashSha256(16);
