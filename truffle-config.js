// 使用种子方式固定账号
const HDWalletProvider = require('@truffle/hdwallet-provider');

require("config.js");

module.exports = {
    networks: {
        // 本地环境
        dev: {
            provider: () => new HDWalletProvider(mnemonic, `http://127.0.0.1:7545`),
            network_id: "*",       // Any network (default: none)
            gas: 7500000,
            gasPrice: 1000000000,
            networkCheckTimeout:600000,
            host: "127.0.0.1",     // Localhost (default: none)
            port: 8545            // Standard Ethereum port (default: none)
        },
        // 测试环境
        bsctest: {
            provider: () => new HDWalletProvider(privatekey, `https://data-seed-prebsc-1-s1.binance.org:8545`),
            network_id: "*",       // Any network (default: none)
            networkCheckTimeout:60000,
            gas: 7500000,
            gasPrice: 10000000000,
            host: "data-seed-prebsc-1-s1.binance.org",     // Localhost (default: none)
            port: 8545,            // Standard Ethereum port (default: none)
            schema: "https"
        }
    },

    mocha: {
        // timeout: 100000
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.8.7",    // solidity版本，需要与代码中实际使用的版本一致，否则会报警
            // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
            settings: {          // See the solidity docs for advice about optimization and evmVersion
                optimizer: {
                    enabled: true,
                    runs: 200
                },
                //  evmVersion: "byzantium"
            }
        }
    },

    db: {
        enabled: false
    }
};
