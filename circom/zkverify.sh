#!/bin/bash

WORKDIR=work/$1

#検証用の鍵をもって，public.jsonに対して証明proof.jsonが正しいか検証．
echo "24. Verify the proof"
npx snarkjs plonk verify $WORKDIR/verification_key.json $WORKDIR/public.json $WORKDIR/proof.json

