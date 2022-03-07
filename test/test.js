 const ERC998ERC1155TopDownPresetMinterPauser = artifacts.require("ERC998ERC1155TopDownPresetMinterPauser");
const ERC1155PresetMinterPauser = artifacts.require("ERC1155PresetMinterPauser");
const web3 = require('web3');

contract("SNFTERC998ERC1155TopDownPresetMinterPauser", accounts => {
  let admin;

  let SNFTerc998;
  let erc1155;
  let composable1 = 1;
  let composable2 = 2;
  let multiTokenTier0 = 0;  //tier 0
  let multiTokenTier1 = 1;  //tier 1
  let multiTokenTier2 = 2;  //tier 2
  let user1 = accounts[1];
  let user2 = accounts[2];

  before(async () => {
    admin = accounts[0];
    let multiTokenMaxSuply = 100;
    // deploy erc1155 ie tier factory
    erc1155 = await ERC1155PresetMinterPauser.new("https://ERC1155.com/{id}", { from: admin });
    // MINTING TIERS
    erc1155.mint(admin, multiTokenTier0, multiTokenMaxSuply, "0x");
    erc1155.mint(admin, multiTokenTier1, multiTokenMaxSuply, "0x");
    erc1155.mint(admin, multiTokenTier2, multiTokenMaxSuply, "0x");
  });

  // minting 998 composables {composable 998)) FOR EACH USER}
  beforeEach(async () => {
    SNFTerc998 = await SNFTERC998ERC1155TopDownPresetMinterPauser.new("SNFT", "cR8erSYMBOL", "https://SNFT-ERC998.com/{id}", { from: admin });
    await SNFTerc998.mint(user1, composable1, { from: admin });
    await SNFTerc998.mint(user2, composable2, { from: admin });
  })

  it("receive child", async () => {
    await erc1155.safeTransferFrom(admin, SNFTerc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier0), 1);
  });

  it("transfer child to other SNFTerc998", async () => {
    await erc1155.safeTransferFrom(admin, SNFTerc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
    await SNFTerc998.safeTransferChildFrom(composable1, SNFTerc998.address, erc1155.address, multiTokenTier0, 1, web3.utils.encodePacked(composable2), { from: user1 });
    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier0), 0);
    assert.equal(await SNFTerc998.childBalance(composable2, erc1155.address, multiTokenTier0), 1);
  });
// childBAlance(SNFTerc998 composable, address oof erc1155 tier token ,   )
  it("batched receive", async () => {
    await erc1155.safeBatchTransferFrom(admin, SNFTerc998.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable1));

    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier1), 1);
    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier2), 1);
  });

  it("batched child transfer", async () => {
    await erc1155.safeBatchTransferFrom(admin, SNFTerc998.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable1));
    await SNFTerc998.safeBatchTransferChildFrom(composable1, SNFTerc998.address, erc1155.address, [multiTokenTier1, multiTokenTier2], [1, 1], web3.utils.encodePacked(composable2), { from: user1 });

    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier1), 0);
    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier2), 0);

    assert.equal(await SNFTerc998.childBalance(composable2, erc1155.address, multiTokenTier1), 1);
    assert.equal(await SNFTerc998.childBalance(composable2, erc1155.address, multiTokenTier2), 1);
  });

  it("childAmountAt and childIdAtIndex", async () => {
    await erc1155.safeBatchTransferFrom(admin, SNFTerc998.address, [multiTokenTier1, multiTokenTier2], [3, 3], web3.utils.encodePacked(composable1));

    const childContracts = await SNFTerc998.childContractsFor(composable1);
    assert.equal(childContracts.length, 1);
    assert.equal(childContracts[0], erc1155.address);


    const childIds = await SNFTerc998.childIdsForOn(composable1, erc1155.address);
    assert.equal(childIds[0], multiTokenTier1);
    assert.equal(childIds[1], multiTokenTier2);

    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier1), 3);
    assert.equal(await SNFTerc998.childBalance(composable1, erc1155.address, multiTokenTier2), 3);
  });
});






/*
// snft -> creator launches 998nft
          (name,, symbol, uri )



*/