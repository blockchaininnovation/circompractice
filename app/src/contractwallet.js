const { createPublicClient, http } = require('viem');
const { privateKeyToAccount } = require('viem/accounts');
const { ethers } = require('ethers');
const fs = require('fs');

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
    "function testmethod() public pure returns (uint256)"
];

async function callTestMethod() {
    try {
        // ethersを使用してコントラクトインスタンスを作成
        const contract = new ethers.Contract(contractAddress, abi, wallet);

        // testmethodの呼び出し
        const result = await contract.testmethod();

        console.log(`testmethod result: ${result.toString()}`);

    } catch (error) {
        console.error('Transaction failed:', error);
    }
}

// テストケースの実行
callTestMethod();
