const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155PresetMinterPauser = artifacts.require("ERC1155PresetMinterPauser");


let name    = "fun";
let symbol  = "FUN";
let baseURI = "fun.com/{id}";
let csnftPrice = 1000;

// name, string memory symbol, string memory baseURI
module.exports = function (deployer) {
  // deployer.deploy(ERC998ERC1155TopDownPresetMinterPauser, name, symbol, baseURI,csnftPrice);
  deployer.deploy(ERC1155PresetMinterPauser,"https://ERC1155.com/{id}",  name, symbol, baseURI,csnftPrice);
};
