const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155PresetMinterPauser = artifacts.require("ERC1155PresetMinterPauser");


let name  = "";
let symbol = "";
let baseURI ="";
let csnftPrice = 1000;

// name, string memory symbol, string memory baseURI
module.exports = function (deployer) {
 deployer.deploy(ERC998ERC1155TopDownPresetMinterPauser, name, symbol, baseURI,csnftPrice);
  deployer.deploy(ERC1155PresetMinterPauser,"https://ERC1155.com/{id}");
};
