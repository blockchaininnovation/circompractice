const snarkjs = require("snarkjs");
const fs = require('fs');

async function execute_sha256() {
    const $in = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1];

    console.log("gen proof start")
    startTime = Date.now(); // 開始時間
    const { proof, publicSignals } = await snarkjs.plonk.fullProve({ in: $in },
        "../circom/work/hash_sha256/hash_sha256_js/hash_sha256.wasm",
        "../circom/work/hash_sha256/circuit_final.zkey");

    endTime = Date.now(); // 終了時間
    console.log("result :", publicSignals);
    console.log("proof gen time: ", endTime - startTime, " [ms]");

    fs.writeFileSync('./result/hash_sha256.json', JSON.stringify(publicSignals, null, '    '));
    fs.writeFileSync('./result/hash_sha256_proof.json', JSON.stringify(proof, null, '    '));
    process.exit(0);
}

async function execute_mimc() {
    const $in = 10101;

    console.log("gen proof start")
    startTime = Date.now(); // 開始時間
    const { proof, publicSignals } = await snarkjs.plonk.fullProve({ in: $in },
        "../circom/work/hash_mimc/hash_mimc_js/hash_mimc.wasm",
        "../circom/work/hash_mimc/circuit_final.zkey");

    endTime = Date.now(); // 終了時間
    console.log("result :", publicSignals);
    console.log("proof gen time: ", endTime - startTime, " [ms]");

    fs.writeFileSync('./result/hash_mimc.json', JSON.stringify(publicSignals, null, '    '));
    fs.writeFileSync('./result/hash_mimc_proof.json', JSON.stringify(proof, null, '    '));
    process.exit(0);
}


execute_sha256();
// execute_mimc();