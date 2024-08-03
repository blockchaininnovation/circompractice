const { createPublicClient, http, parseEther } = require('viem');
const { privateKeyToAccount } = require('viem/accounts');
const { ethers } = require('ethers');
const fs = require('fs');
const snarkjs = require('snarkjs');


// config.jsonの読み込み
const config = JSON.parse(fs.readFileSync('config.json', 'utf-8'));

// ブロックチェーン接続の設定
const client = createPublicClient({
    chain: {
        id: config.blockchain.chainId,
        name: config.blockchain.network,
        network: config.blockchain.network,
        nativeCurrency: {
            name: 'Ether',
            symbol: 'ETH',
            decimals: 18,
        },
    },
    transport: http(config.blockchain.rpcUrl),
});

// アカウント情報の設定
const privateKey = config.account.privateKey;
const account = privateKeyToAccount(privateKey);

// ethersを使用してウォレットを作成
const provider = new ethers.providers.JsonRpcProvider(config.blockchain.rpcUrl);
const wallet = new ethers.Wallet(privateKey, provider);

// コントラクトのアドレスとABIの設定
const contractAddress = config.contract.address;
const abi = [
    "function testmethod() public pure returns (uint256)",
    "function transfer(address payable send_to, uint amount, uint256[24] calldata _proof, uint256[2] calldata _pubSignals) public",
    "function deposit() public payable",
    "function getTotalBalance() public view returns (uint256)"
];

const contract = new ethers.Contract(contractAddress, abi, wallet);

async function callTestMethod() {
    try {
        const result = await contract.testmethod();

        console.log(`testmethod result: ${result.toString()}`);

    } catch (error) {
        console.error('Transaction failed:', error);
    } finally {
        process.exit(0);
    }
}

async function getTotalBalance() {
    try {
        const result = await contract.getTotalBalance();

        console.log(`getTotalBalance() result: ${result.toString()}`);

    } catch (error) {
        console.error('Transaction failed:', error);
    } finally {
        process.exit(0);
    }
}

async function executeTransfer(sendTo, amountInEth, proof, pubSignals) {
    try {
        const amountInWei = parseEther(amountInEth);
        const gasLimit = 1000000;
        const maxFeePerGas = ethers.utils.parseUnits('2', 'gwei');
        const maxPriorityFeePerGas = ethers.utils.parseUnits('1', 'gwei');

        const tx = await contract.transfer(sendTo, amountInWei, proof, pubSignals, {
            gasLimit: gasLimit,
            maxFeePerGas: maxFeePerGas,
            maxPriorityFeePerGas: maxPriorityFeePerGas
        });
        console.log(`Transfer transaction sent: ${tx.hash}`);

        const receipt = await tx.wait();
        console.log(`Transfer confirmed in block: ${receipt.blockNumber}`);
    } catch (error) {
        console.error('Transfer failed:', error);
    } finally {
        process.exit(0);
    }
}

async function executeTransferByFile(sendTo, amountInEth, proofFilePath, pubSignalsFilePath) {
    try {
        const proofJSON = fs.readFileSync(proofFilePath, 'utf8');
        const publicSignalsJSON = fs.readFileSync(pubSignalsFilePath, 'utf8');

        const proof = JSON.parse(proofJSON);
        const publicSignals = JSON.parse(publicSignalsJSON);

        const rawCalldata = await snarkjs.plonk.exportSolidityCallData(proof, publicSignals);
        // console.log("rawCalldata: " + rawCalldata)
        const s = rawCalldata.split("][");

        const ss_proof = s[0].replace("[", "")
            .replace("]", "")
            .replace("\\", "")
            .replace(/0x/g, "")
            .replace(/"/g, "")
            .replace(" ", "")
            .split(",");
        // console.log("ss_proof: " + ss_proof.length + " " + ss_proof);

        const ss_pub = s[1].replace("[", "")
            .replace("]", "")
            .replace("\\", "")
            .replace(/0x/g, "")
            .replace(/"/g, "")
            .replace(" ", "")
            .split(",");
        // console.log("ss_pub: " + ss_pub.length + " " + ss_pub);

        const proofForContract = [];
        for (let i = 0; i < ss_proof.length; i++) {
            const s = ss_proof[i];
            // console.log("s: " + s);
            proofForContract.push(BigInt("0x" + s));
        }

        const publicSignalsForContract = [];
        for (let i = 0; i < ss_pub.length; i++) {
            const s = ss_pub[i];
            console.log("s: " + s);
            publicSignalsForContract.push(BigInt("0x" + s));
        }

        console.log("proofForContract: " + proofForContract.length + " " + proofForContract)
        console.log("publicSignalsForContract: " + publicSignalsForContract.length + " " + publicSignalsForContract)

        await executeTransfer(sendTo, amountInEth, proofForContract, publicSignalsForContract);
    } catch (error) {
        console.error('Failed to load proof or public signals:', error);
        throw error;
    } finally {
        process.exit(0);
    }
}

async function getBalance(address) {
    try {
        const balance = await client.getBalance({
            address: address,
        });
        console.log(`Balance of ${address}: ${ethers.utils.formatEther(balance)} ETH`);
    } catch (error) {
        console.error('Failed to get balance:', error);
    } 
}

async function depositEther(amountInEth) {
    try {
        const amountInWei = parseEther(amountInEth);

        const tx = await contract.deposit({
            value: amountInWei,
            gasLimit: 100000
        });

        console.log(`Deposit transaction sent: ${tx.hash}`);

        const receipt = await tx.wait();
        console.log(`Deposit confirmed in block: ${receipt.blockNumber}`);
    } catch (error) {
        console.error('Deposit failed:', error);
    } finally {
        process.exit(0);
    }
}
// テストケースの実行
getBalance("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
getBalance("0x70997970C51812dc3A010C7d01b50e0d17dc79C8");

// callTestMethod();
// depositEther("100");
// getTotalBalance();
executeTransferByFile("0x70997970C51812dc3A010C7d01b50e0d17dc79C8", "10", "../circom/work/auth/proof.json", "../circom/work/auth/public.json");

