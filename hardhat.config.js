require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');

module.exports = {
    solidity: "0.8.0",
    networks: {
        bsc: {
            url: "https://bsc-dataseed.binance.org/",
            accounts: [`0x${process.env.PRIVATE_KEY}`]
        }
    },
    etherscan: {
        apiKey: process.env.BSCSCAN_API_KEY
    }
};