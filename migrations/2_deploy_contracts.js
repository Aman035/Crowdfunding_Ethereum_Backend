var CampaignCreator = artifacts.require("CampaignCreator");

module.exports = async function(deployer) {
  await deployer.deploy(CampaignCreator);
};
