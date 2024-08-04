pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template MyFunc() {
    signal input w;
    signal input a;
    signal input b;
    signal output out;
    
    component ise = IsEqual();
    ise.in[0] <== w;
    ise.in[1] <== 1;

    signal t1;
    t1 <== a * (b + 3);

    signal t2;
    t2 <== ise.out * t1;
    out <== t2 + (1- ise.out) * (a + b);
}

component main = MyFunc();
