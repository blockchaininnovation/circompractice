pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template Cubic() {
    signal input in;
    signal output out;
    
    // x^3 + x + 5を出力
    signal t;
    t <== in * in;
    out <== t * in + in + 5;
}

component main = Cubic();
