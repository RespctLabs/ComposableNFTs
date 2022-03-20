// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
///@dev handle Batch receiving function - !!!!

/// @title ERC1155TUMP creates tier supply and attaches tier to composable
/// @author respect-club
/// @notice receives Engagement tokens and attaches tier to composable
/// @dev 1155 tokenId reserved for engagement token

/// @notice
import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";
import "./ERC998ERC1155TopDownPresetMinterPauser.sol";

/*
    erc1155.mint(admin, multiTokenTier0, multiTokenMaxSuply, "0x");
    erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
*/
contract ERC1155TierUpgradePresetMinterPauser is ERC1155PresetMinterPauser {
    bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))

    ERC998ERC1155TopDownPresetMinterPauser csnftContract;

    /// @notice csnft contract is deployed and linked to ERC1155TUMP
    /// @param _csnftContractAdr deployed csnft contract

    constructor(string memory tierUri, address _csnftContractAdr)
        public
        ERC1155PresetMinterPauser(tierUri)
    {
        require(
            _csnftContractAdr != address(0),
            "ERC998: transfer to the zero address"
        );

        csnftContract = ERC998ERC1155TopDownPresetMinterPauser(
            _csnftContractAdr
        );
    }

    /// claimF engagement points
    //function claim(){}

    /// @notice upgrade user tier
    /// @dev fetch curent tier of msg.sender
    /// msg.value user sends
    function upgradeSNFT(
        uint256 _composableId,
        uint256 _upgradeToTierId, // upgrade to
        bytes calldata data // web3.utils.encodePacked(composableId)
    ) external payable {
        //add tier checks  if tierId =1 bal(t-1) == 1
        // at t=0 bal(0) >= _FengagementPOints
        require(_upgradeToTierId != 0);

        uint256 upgradeCost = csnftContract.getTierPrice(_upgradeToTierId-1);
        require(balanceOf(msg.sender, 0) >= upgradeCost, "Doesnt have enough Engagement"); // have enough Engagment points at
        require(balanceOf(msg.sender, _upgradeToTierId - 1) >= 1);
        burn(msg.sender, 0, upgradeCost); // burn engagement tid 0

        _mint(address(csnftContract), _upgradeToTierId, 1, data);
    }

    // implement function to mint | claim F(creators engagement ) at tokenId 0
}
