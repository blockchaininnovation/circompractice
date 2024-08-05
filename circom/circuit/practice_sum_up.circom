pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "./hash.circom";

template SumUp(n) {
    signal input in[n];
    signal output out;

    component lt[n];
    signal sums[n+1];
    sums[0] <== 0;
    for(var i = 0; i < n; i++){
        lt[i] = LessThan(252);
        lt[i].in[0] <== in[i];
        lt[i].in[1] <== 3;
        sums[i+1] <== sums[i] + lt[i].out;
    }
    out <== sums[n];
}

component main = SumUp(4);
