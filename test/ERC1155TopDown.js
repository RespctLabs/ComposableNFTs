// const ComposableParentERC721 = artifacts.require("ComposableParentERC721");
// const ERC1155PresetMinterPauser = artifacts.require("ERC1155PresetMinterPauser");
// const web3 = require('web3');

// contract("ComposableParentERC721", accounts => {
//   let admin;
//   let erc998;
//   let erc1155;
//   let composable1 = 1;
//   let composable2 = 2;
//   let multiTokenTier0 = 0;  //tier 0
//   let multiTokenTier1 = 1;  //tier 1
//   let multiTokenTier2 = 2;  //tier 2
//   let user1 = accounts[1];
//   let user2 = accounts[2];

//   before(async () => {
//     admin = accounts[0];
//     let multiTokenMaxSuply = 100;
//     // deploy erc1155 ie tier factory
//     erc1155 = await ERC1155PresetMinterPauser.new("https://ERC1155.com/{id}", { from: admin });
//     // MINTING TIERS
//     erc1155.mint(admin, multiTokenTier0, multiTokenMaxSuply, "0x");
//     erc1155.mint(admin, multiTokenTier1, multiTokenMaxSuply, "0x");
//     erc1155.mint(admin, multiTokenTier2, multiTokenMaxSuply, "0x");
//   });

//   // minting 998 composables {composable 998)) FOR EACH USER}
//   beforeEach(async () => {
//     erc998 = await ComposableParentERC721.new("erc998", "ERC998", "https://ERC998.com/{id}", { from: admin });
//     await erc998.mint(user1, composable1, { from: admin });
//     await erc998.mint(user2, composable2, { from: admin });
//   })
// /// @param
// /// @param
// /// @param
// /// @param

//   it("receive tier0", async () => {
//     await erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier0), 1);
//   });
//   it("receive tier0 again,should fail", async () => {
//     await erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
//     assert.equal3(await erc998.childBalance(composable1, erc1155.address, multiTokenTier0), 2);
//   });
// // updated functionality, no transfer of child
//   it("transfer child to other erc998, must fail", async () => {
//     await erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
//     await erc998.safeTransferChildFrom(composable1, erc998.address, erc1155.address, multiTokenTier0, 1, web3.utils.encodePacked(composable2), { from: user1 });
//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier0), 0);
//     assert.equal(await erc998.childBalance(composable2, erc1155.address, multiTokenTier0), 1);
//   });
// // childBAlance(erc998 composable, address oof erc1155 tier token ,   )
//   it("batched receive", async () => {
//     await erc1155.safeBatchTransferFrom(admin, erc998.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable1));

//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 1);
//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier2), 1);
//   });

//   it("batched child transfer", async () => {
//     await erc1155.safeBatchTransferFrom(admin, erc998.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable1));
//     await erc998.safeBatchTransferChildFrom(composable1, erc998.address, erc1155.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable2), { from: user1 });

//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 0);
//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier2), 0);

//     assert.equal(await erc998.childBalance(composable2, erc1155.address, multiTokenTier1), 1);
//     assert.equal(await erc998.childBalance(composable2, erc1155.address, multiTokenTier2), 1);
//   });

//   it("childAmountAt and childIdAtIndex", async () => {
//     await erc1155.safeBatchTransferFrom(admin, erc998.address, [multiTokenTier1, multiTokenTier2], [3, 3], web3.utils.encodePacked(composable1));

//     const childContracts = await erc998.childContractsFor(composable1);
//     assert.equal(childContracts.length, 1);
//     assert.equal(childContracts[0], erc1155.address);


//     const childIds = await erc998.childIdsForOn(composable1, erc1155.address);
//     assert.equal(childIds[0], multiTokenTier1);
//     assert.equal(childIds[1], multiTokenTier2);

//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 3);
//     assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier2), 3);
//   });
// });
