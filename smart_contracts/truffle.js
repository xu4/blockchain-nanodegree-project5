var HDWalletProvider = require('truffle-hdwallet-provider');

var mnemonic = 'aware gift when head gossip spider bike corn input juice battle dress';

module.exports = {
  networks: { 
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: "*"
    }, 
    rinkeby: {
      provider: function() { 
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/f2e1e6b841f74c6aa835b5a5506d9f9c') 
      },
      network_id: 4,
      gas: 4500000,
      gasPrice: 10000000000,
    }
  }
};