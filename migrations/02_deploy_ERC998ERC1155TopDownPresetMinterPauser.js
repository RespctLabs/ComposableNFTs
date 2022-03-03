const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155PresetMinterPauser = artifacts.require("ERC1155PresetMinterPauser");


let name  = "pony";
let symbol = "PON";
let baseURI ="google.com";

// name, string memory symbol, string memory baseURI
module.exports = function (deployer) {
  deployer.deploy(ERC998ERC1155TopDownPresetMinterPauser, name, symbol, baseURI);
  deployer.deploy(ERC1155PresetMinterPauser,"https://ERC998.com/{id}");
};
