const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155TierUpgradePresetMinterPauser = artifacts.require("ERC1155TierUpgradePresetMinterPauser");

let name    = "fun";
let symbol  = "FUN";
let baseURI = "fun.com/{id}";
let csnftPrice = 1000;
let tierUri ="https://ERC1155.com/{id}";

// name, string memory symbol, string memory baseURI
module.exports = function (deployer) {
  deployer.deploy(ERC998ERC1155TopDownPresetMinterPauser, name, symbol, baseURI).then(function() {
    return deployer.deploy(ERC1155TierUpgradePresetMinterPauser,tierUri, ERC998ERC1155TopDownPresetMinterPauser.address);
  });
};



