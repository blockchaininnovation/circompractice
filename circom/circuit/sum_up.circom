pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template SumUp(n) {
    signal input in[n];
    signal output out;

    // var sum = 0;
    // for(var i = 0; i < n; i++){
    //     sum = sum + in[i];
    // }
    // out <== sum;
    
    signal sums[n+1];
    sums[0] <== 0;
    for(var i = 0; i < n; i++){
        sums[i+1] <== sums[i] + in[i];
    }
    out <== sums[n];
}

component main = SumUp(4);
