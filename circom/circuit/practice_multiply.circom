pragma circom 2.0.0;

template Multiplier2 () {  

   signal input a;  
   signal input b;  
   signal output c;  

   c <== a * b + 2;
}

component main = Multiplier2();