const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155PresetMinterPauser = artifacts.require("ERC1155PresetMinterPauser");
const web3 = require('web3');

contract("ERC998ERC1155TopDownPresetMinterPauser", accounts => {
  let admin;
   

  
/// @param
/// @param
/// @param

  it("receive child", async () => {
    await erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier0), 1);
  });

  it("transfer child to other erc998", async () => {
    await erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
    await erc998.safeTransferChildFrom(composable1, erc998.address, erc1155.address, multiTokenTier0, 1, web3.utils.encodePacked(composable2), { from: user1 });
    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier0), 0);
    assert.equal(await erc998.childBalance(composable2, erc1155.address, multiTokenTier0), 1);
  });
// childBAlance(erc998 composable, address oof erc1155 tier token ,   )
  it("batched receive", async () => {
    await erc1155.safeBatchTransferFrom(admin, erc998.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable1));

    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 1);
    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier2), 1);
  });

  it("batched child transfer", async () => {
    await erc1155.safeBatchTransferFrom(admin, erc998.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable1));
    await erc998.safeBatchTransferChildFrom(composable1, erc998.address, erc1155.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable2), { from: user1 });

    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 0);
    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier2), 0);

    assert.equal(await erc998.childBalance(composable2, erc1155.address, multiTokenTier1), 1);
    assert.equal(await erc998.childBalance(composable2, erc1155.address, multiTokenTier2), 1);
  });

  it("childAmountAt and childIdAtIndex", async () => {
    await erc1155.safeBatchTransferFrom(admin, erc998.address, [multiTokenTier1, multiTokenTier2], [3, 3], web3.utils.encodePacked(composable1));

    const childContracts = await erc998.childContractsFor(composable1);
    assert.equal(childContracts.length, 1);
    assert.equal(childContracts[0], erc1155.address);


    const childIds = await erc998.childIdsForOn(composable1, erc1155.address);
    assert.equal(childIds[0], multiTokenTier1);
    assert.equal(childIds[1], multiTokenTier2);

    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier1), 3);
    assert.equal(await erc998.childBalance(composable1, erc1155.address, multiTokenTier2), 3);
  });
});
