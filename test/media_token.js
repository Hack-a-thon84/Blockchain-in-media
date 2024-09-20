const MediaToken = artifacts.require("MediaToken");

contract("MediaToken", (accounts) => {
  it("should put 1,000,000 MediaToken in the first account", async () => {
    const instance = await MediaToken.deployed();
    const balance = await instance.balanceOf(accounts[0]);
    assert.equal(balance.toString(), "1000000000000000000000000", "Initial balance incorrect");
  });

  it("should mint new tokens", async () => {
    const instance = await MediaToken.deployed();
    await instance.mint(accounts[1], web3.utils.toWei('100', 'ether'));
    const balance = await instance.balanceOf(accounts[1]);
    assert.equal(balance.toString(), web3.utils.toWei('100', 'ether'), "Minting failed");
  });
});