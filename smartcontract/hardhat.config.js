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
  networks:{
    polygon:{
      url:'https://polygon-mainnet.g.alchemy.com/v2/TggBDBnXKMem2E_JsIvEze3LLwnmGE5S',
      accounts:['1f7f16e0abbf3821cd88933b0f0dff23c1b55c08b5ef022e61473cdda6bff80c']
    }
  }
};
