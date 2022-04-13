const { expect } = require("chai");
const { formatEther, parseEther } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

// const BN = require('bn.js');


// chai.use(require('bn.js')(BN));

//default state
  let snftName = "creatorXsnft"
  let snftSymbol = "ERC998"
  let snftURI = "https://ERC998.com/{id}"

  let childURI = "https://ERC1155.com/{id}"
  let composable1 = 1;
  let composable2 = 2;

  let mintCost = '2'; //
  // let multiTokenTier0 = 0;  //tier 0
  let multiTokenTier1 = 1; //tier 1
  let multiTokenTier2 = 2; //tier 2

  let tierUpgradeCost1 = 500;
  let tierUpgradeCost2 = 600;

  describe('SNFT System Unit Test',function(){

    before(async function () {
    //Deploy Parent SNFT Minter Pauser Contract
        ComposableParentERC721 = await ethers.getContractFactory('ComposableParentERC721')
        parent = await ComposableParentERC721.deploy(
              snftName,
              snftSymbol,
              snftURI,
              tierUpgradeCost1 )
        await parent.deployed()

    //Deploy Child Tier Upgrade Minter Pauser Contract
        ComposableChildrenERC1155 = await ethers.getContractFactory('ComposableChildrenERC1155')
        child = await ComposableChildrenERC1155.deploy(childURI, parent.address)
        await child.deployed()
        // console.log(parent.address)
    })

    beforeEach(async function() {
        await parent.getComposableCount();
        const [owner, addr1] = await ethers.getSigners();

    })

    it('should return csnft count  ', async function(){
        //default to 0
        expect((await parent.getComposableCount()).toString()).to.equal('0')
    })
    it('child URI check ', async function(){
        expect((await child.uri(0)).toString()).to.equal(childURI)
    })
    it('should return tier upgrade cost once its changed ', async function(){

        const setTierUpgradeTx = await parent.setTierUpgradeCost(multiTokenTier1, 99);
        await setTierUpgradeTx.wait();
        expect((await parent.getTierUpgradeCost(multiTokenTier1)).toString()).to.equal('99');
    })
    it('should return mint cost after changing', async function(){
        await parent.setMintCost(1)
        expect((await parent.getMintCost()).toString()).to.equal('1')
    })
    it('should return csnft max supply after changing',async function(){
        const changeMaxSupplyTx =  await parent.changeMaxSupply(200);
        await changeMaxSupplyTx.wait();
        expect((await parent.getMaxSupply()).toString()).to.equal('200');
    })

    it('should mint snft on receiving ether',async function(){
        const [owner, addr1, addr2] = await ethers.getSigners();
        //user1 mints snft composable1
        const snftMintC1Tx = await (parent.connect(addr1).mint( {value: ethers.utils.parseUnits('1','wei') }));
        await snftMintC1Tx.wait();

        expect((await parent.balanceOf(addr1.address)).toString()).to.equal('1');

        // //user2 mints snft composable2
        // const snftMintC2Tx = await (parent.connect(addr2).mint( {value: ethers.utils.parseUnits('1','wei') }));
        // await snftMintC2Tx.wait();

        // expect((await parent.balanceOf(addr2.address)).toString()).to.equal('1')
    })

    it('should mint engagement points',async function (){
        const [owner, addr1] = await ethers.getSigners();
        // console.log(addr1.address);

        const mintEngagementPointsTx = await child.connect(addr1).mintEngagementPoints(addr1.address, 500, "0x00");
        await mintEngagementPointsTx.wait();

        expect((await child.balanceOf(addr1.address, 0)).toString()).to.equal('500');
    })

    it('should upgrade snft',async function(){
        const [owner, addr1, addr2] = await ethers.getSigners();
        //user1 mints snft composable1
        const snftMintC1Tx = await (parent.connect(addr2).mint( {value: ethers.utils.parseUnits('1','wei') }));
        await snftMintC1Tx.wait();

        expect((await parent.balanceOf(addr2.address)).toString()).to.equal('1');
        const mintEngagementPointsTx = await child.connect(addr2).mintEngagementPoints(addr1.address, 500, "0x00");



    //Upgrade snft to tier 2
        const upgradeSNFTtx = await child.connect(addr2).upgradeSNFT(
            composable1,
            multiTokenTier1,
            ethers.utils.solidityPack(composable1)
          );
        await upgradeSNFTtx.wait();

        expect(await parent.getLevel(composable1, child.address).toString()).to.equal('1 ');

    })
})



describe('Minting', async function(){
    before(async function () {
        ComposableParentERC721 = await ethers.getContractFactory('ComposableParentERC721')
        parent = await ComposableParentERC721.deploy(
              snftName,
              snftSymbol,
              snftURI,
              tierUpgradeCost1)
        await parent.deployed()

        ComposableChildrenERC1155 = await ethers.getContractFactory('ComposableChildrenERC1155')
        child = await ComposableChildrenERC1155.deploy(childURI, parent.address)
        await child.deployed()

    })
    // it('initial csnft count is 0 ',async function(){
    //     expect((await parent.getComposableCount()).toString()).to.equal('0')
    // })

    // it('miniting snft',async function(){
    //     expect((await parent.getComposableCount()).toString()).to.equal('1')
    // })
    // it('mint engagement point',async function (){
    //     await erc1155.connect(addr1).mintEngagementPoints(addr1,500,"0x0");
    //     expect((await childContract.balanceOf(addr1, 0)).toString.to.equal('500'))
    // })

})