pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template Cubic() {
    signal input in;
    signal output out;
    
    // 𝑥^4+12𝑥+1を出力
    signal t1;
    t1 <== in * in;
    signal t2;
    t2 <== t1 * in;

    out <== t2 * in + 12 * in + 1;
}

component main = Cubic();
