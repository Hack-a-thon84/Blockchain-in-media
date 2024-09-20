const MediaToken = artifacts.require("MediaToken");

module.exports = function(deployer) {
  const initialSupply = 1000000; // 1 million tokens
  deployer.deploy(MediaToken, initialSupply);
};