// const ComposableParentERC721 = artifacts.require("ComposableParentERC721");
// const ComposableChildrenERC1155 = artifacts.require(
//   "ComposableChildrenERC1155"
// );
// const web3 = require("web3");

// contract("ComposableParentERC721", (accounts) => {
//   let admin;
//   let parentContract;
//   let childContract;
//   let composable1 = 1;
//   // let composable2 = 2;
//   // let multiTokenTier0 = 0;  //tier 0
//   let multiTokenTier1 = 1; //tier 1
//   let multiTokenTier2 = 2; //tier 2
//   let user1 = accounts[1];
//   // let user2 = accounts[2];
//   let tierUpgradeCost1 = 500;
//   let tierUpgradeCost2 = 600;

//   //deploy contracts ERC998TDMP , ERC1155TUMP

//   beforeEach(async () => {
//     admin = accounts[0];
//     parentContract = await ComposableParentERC721.new(
//       "parentContract",
//       "ERC998",
//       "https://ERC998.com/{id}",
//       tierUpgradeCost1,
//       { from: admin }
//     );
//     childContract = await ComposableChildrenERC1155.new(
//       "https://ERC1155.com/{id}",
//       parentContract.address,
//       { from: admin }
//     );

//     await parentContract.mint({ from: user1, value: web3.utils.toWei("2") });
//     parentContract.setTierUpgradeCost(multiTokenTier2, tierUpgradeCost2);
//     // await childContract.mint(user1,100);
//     // await parentContract.mint(user2, composable2, { from: admin });
//   });

//   it("Verified ERC998, ERC1155TU", async () => {
//     assert.equal(await parentContract.name(), "parentContract");
//     console.log(parentContract.address);
//   });
//   it("parentContract : check state var", async () => {
//     assert.equal(await parentContract.name(), "parentContract");
//     console.log(parentContract.address);
//   });

// // check if user csnft Balance
//   it ("BURN CHECK ", async() => {
//     await erc1155.mintEngagementPoints(user1,1000,"0x0");

//     console.log(await erc1155.balanceOf(user1,0));
//     await erc1155.upgradeSNFT(composable1, multiTokenTier1, web3.utils.encodePacked(composable1),{from:user1});
//     res = await erc998.childBalance(composable1, erc1155.address, multiTokenTier1);
//     // assert.equal(res,1);
//     console.log("1.>>>>>>>>>>>>>>>>");
//     console.log(await erc1155.balanceOf(user1,1));
// // BURN
//     tx_burn = await erc998.burn(composable1,{from:user1});

//     await erc1155.upgradeSNFT(composable1, multiTokenTier1, web3.utils.encodePacked(composable1),{from:user1});
//     res = await erc998.childBalance(composable1, erc1155.address, multiTokenTier1);
//     assert.equal(res,1);

//     console.log("2.>>>>>>>>>>>>>>>>");
//     console.log(await erc1155.balanceOf(user1,1));
//   });

//   // it ("", async() => {
//   //   // assert.equal(await erc998.balanceOf(user2),1);
//   // });

//   it ("check 998 setters and getters", async() => {
//     await erc998.setTierUpgradeCost(multiTokenTier1,tierUpgradeCost2);

//     assert.equal((await erc998.getTierUpgradeCost(multiTokenTier1)).toString() , (tierUpgradeCost2).toString());
//     // assert.equal(await erc998.balanceOf(user2),1);
//   });

//   it ("User1 has 500 engagement points", async() => {
//     await erc1155.mintEngagementPoints(user1,500,"0x0");

//     assert.equal(
//       (await parentContract.getTierUpgradeCost(multiTokenTier1)).toString(),
//       tierUpgradeCost2.toString()
//     );
//     // assert.equal(await parentContract.balanceOf(user2),1);
//   });

//   it("User1 has 500 engagement points", async () => {
//     await childContract.mintEngagementPoints(user1, 500, "0x0", {
//       from: user1,
//     });

//     assert.equal(
//       (await childContract.balanceOf(user1, 0)).toString(),
//       (500).toString()
//     );
//     // assert.equal(await parentContract.balanceOf(user2),1);
//   });

//   it("Upgrade composable1", async () => {
//     await childContract.mintEngagementPoints(user1, 500, "0x0");

//     console.log(await childContract.balanceOf(user1, 0));
//     await childContract.upgradeSNFT(
//       composable1,
//       multiTokenTier1,
//       web3.utils.encodePacked(composable1),
//       { from: user1 }
//     );
//     res = await parentContract.childBalance(
//       composable1,
//       childContract.address,
//       multiTokenTier1
//     );
//     assert.equal(res, 1);
//     tx = await parentContract.childIdsForOn(composable1, childContract.address);
//     // console.log(">>>>>>>>>>>>>>>>");
//     // console.log(tx);
//     // console.log(">>>>>>>>>>>>>>>>");
//     // console.log(await childContract.balanceOf(user1,1));
//   });

//   it("Composable 1 , receive upgrade to tier1 then tier2", async () => {
//     await childContract.mintEngagementPoints(user1, 500, "0x0");
//     assert.equal(
//       await parentContract.getLevel(composable1, childContract.address),
//       0
//     );
//     //UPGRADING to tier

//     await childContract.upgradeSNFT(
//       composable1,
//       multiTokenTier1,
//       web3.utils.encodePacked(composable1),
//       { from: user1 }
//     );

//     assert.equal(
//       await parentContract.childBalance(
//         composable1,
//         childContract.address,
//         multiTokenTier1
//       ),
//       1
//     );
//     assert.equal(
//       await parentContract.getLevel(composable1, childContract.address),
//       1
//     );

//     //UPGRADING to tier2
//     await childContract.mintEngagementPoints(user1, 600, "0x0");
//     await childContract.upgradeSNFT(
//       composable1,
//       multiTokenTier2,
//       web3.utils.encodePacked(composable1),
//       { from: user1 }
//     );

//     // assert.equal(await parentContract.childBalance(composable1, childContract.address, multiTokenTier2),1);
//     assert.equal(
//       await parentContract.getLevel(composable1, childContract.address),
//       2
//     );
//   });
// });
