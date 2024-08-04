pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template RangeCheck() {
    signal input in;
    signal input lowerBound;
    signal input upperBound;
    signal output out;

    component le1 = LessEqThan(252);
    component le2 = LessEqThan(252);

    le1.in[0] <== lowerBound;
    le1.in[1] <== in;

    le2.in[0] <== in;
    le2.in[1] <== upperBound;

    out <== le1.out * le2.out;
}

component main = RangeCheck();
