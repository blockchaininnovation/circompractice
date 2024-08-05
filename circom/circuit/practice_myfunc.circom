pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template MyFunc() {
    signal input w;
    signal input a;
    signal input b;
    signal output out;
    
    component gt = GreaterThan(252);
    gt.in[0] <== w;
    gt.in[1] <== 10;

    signal t;
    t <== gt.out * (a + b);
    out <== t + (1- gt.out) * (a - b);
}

component main = MyFunc();
