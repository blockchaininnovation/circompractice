pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template SumUp(n) {
    signal input in;
    signal output out;

    var sum = 0;
    for(var i = 1; i <= n; i++){
        sum = sum + in;
    }

    out <== sum;
}

component main = SumUp(10);
