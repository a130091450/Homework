require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",

  networks: {
    // 本地环境
    dev: {
      // provider: () => new HDWalletProvider(privatekey, `http://127.0.0.1:8545`),
      // network_id: "*",       // Any network (default: none)
      // gas: 7500000,
      // gasPrice: 7500000,
      // networkCheckTimeout:10000,
      // host: "127.0.0.1",     // Localhost (default: none)
      // port: 8545            // Standard Ethereum port (default: none)
      url: `http://127.0.0.1:8545`,
      chainId: 5,
    },
    // 测试环境
    bsctest: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
      chainId: 5,
    }
  }
};
