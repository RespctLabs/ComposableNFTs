const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155TierUpgradePresetMinterPauser = artifacts.require("ERC1155TierUpgradePresetMinterPauser");
const web3 = require('web3');

contract("ERC998ERC1155TopDownPresetMinterPauser", accounts => {
  let admin;
  let erc998;
  let erc1155;
  let composable1 = 1;
  let composable2 = 2;
  let multiTokenTier0 = 0;  //tier 0
  let multiTokenTier1 = 1;  //tier 1
  let multiTokenTier2 = 2;  //tier 2
  let user1 = accounts[1];
  let user2 = accounts[2];
  let engagementPoint0 = 100;
//deploy contracts ERC998TDMP , ERC1155TUMP

  before (async () => {
    admin = accounts[0];
    erc998 = await  ERC998ERC1155TopDownPresetMinterPauser.new("erc998", "ERC998", "https://ERC998.com/{id}",engagementPoint0, { from: admin });
    erc1155 = await ERC1155TierUpgradePresetMinterPauser.new("https://ERC1155.com/{id}", erc998.address, { from: admin });
    erc998.mint(user1);
    console.log(erc998.address);
    // await erc998.mint(user1, composable1, { from: admin });
    // await erc998.mint(user2, composable2, { from: admin });
  });
  beforeEach(async () => {
    erc1155.mint(erc998.address, 0, 500000,web3.utils.encodePacked(composable1), { from: admin });
  });

  describe ("ERC998TDMP", () => {
    it ("Verified ERC998, ERC1155TU", async() => {
      assert.equal(await erc998.name(),"erc998");
      console.log(erc998.address);
    });
  // check if user csnft Balance
    it ("User1 has composable1", async() => {
      assert(await erc998.balanceOf(user1),1);
    });

    it ("Total Supply $F", async() => {
      assert(await erc998.childBalance(composable1, erc1155.address, 0),500000);
      assert(await erc1155.balanceOf(user1, 0), 500000);
      console.log(await erc998.getTierPrice(0));
    })

    it('Upgrade SNFT successfully', async () =>  {
      erc1155.upgradeSNFT(composable1, multiTokenTier1,web3.utils.encodePacked(composable1), { from: admin });
      // console.log(tx);
      // console.log(erc998.childBalance(composable1, erc1155.address, multiTokenTier1))
      assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 1);
    })
  });

// /// @param
// /// @param
// /// @param
// /// @param

  // it("child balance should fail", async () => {
  //   // await erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
  //   assert.equal(await erc998.childBalance(composable1, tierUpgradeContract.address, multiTokenTier0), 1);
  //   assert.equal(await erc998.childBalance(composable2, tierUpgradeContract.address, multiTokenTier0), 1);
  // });
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
});
