pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template Cubic() {
    signal input in;
    signal output out;
    
    // x^3 + x + 5を出力
    signal t1;
    t1 <== in * in;
    out <== t1 * in + in + 5;
}

component main = Cubic();
