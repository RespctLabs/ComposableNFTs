const ComposableParentERC721 = artifacts.require("ComposableParentERC721");
const ComposableChildrenERC1155 = artifacts.require("ComposableChildrenERC1155");

let name    = "fun";
let symbol  = "FUN";
let baseURI = "fun.com/{id}";
let csnftPrice = 1000;
let tierUri ="https://ERC1155.com/{id}";
let engagementPoint0 = 100;
// name, string memory symbol, string memory baseURI
module.exports = function (deployer) {
  deployer.deploy(ComposableParentERC721, name, symbol, baseURI,engagementPoint0).then(function() {
    return deployer.deploy(ComposableChildrenERC1155,tierUri, ComposableParentERC721.address);
  });
};



