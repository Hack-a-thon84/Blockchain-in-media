const HDWalletProvider = require("@truffle/hdwallet-provider");
const infuraKey = "YOUR_INFURA_PROJECT_ID";
const mnemonic = "your metamask seed phrase";

module.exports = {
  networks: {
    ropsten: {
      provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraKey}`),
      network_id: 3,       // Ropsten's id
      gas: 5500000,        // Gas limit
      confirmations: 2,    // # of confirmations to wait
      timeoutBlocks: 200,  // # of blocks before a deployment times out
      skipDryRun: true     // Skip dry run before migrations
    }
  },
  compilers: {
    solc: {
      version: "0.8.0",    // Fetch exact version from solc-bin
    }
  }
};
