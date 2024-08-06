pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";
include "./hash.circom";

template SumUp(n) {
    signal input in[n];
    signal output out;

    // 回路を記述してください．

}

component main = SumUp(4);
