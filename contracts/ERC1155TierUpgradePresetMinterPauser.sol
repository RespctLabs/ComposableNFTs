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
    /// @param _to csnftContract Address
    /// @param _amount of F engagement  points
    /// @param _data web3.utils.encodePacked(composableId)
    function mintEngagementPoints(
        address _to,
        uint256 _amount,
        bytes memory _data
    ) public {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "ERC1155TUMP unauthorized engagement minter"
        );

        mint(_to, 0, _amount, _data);
    }

    /// @notice upgrade user tier
    /// @dev fetch curent tier of msg.sender
    /// msg.value user sends
    function upgradeSNFT(
        address _to, //  a/c of owner of snft
        uint256 _composableId,
        uint256 _upgradeToTierId, // upgrade to
        bytes calldata data // web3.utils.encodePacked(composableId)
    ) external returns (bool) {
        //add tier checks  if tierId =1 bal(t-1) == 1
        // at t=0 bal(0) >= _FengagementPOints
        require(_upgradeToTierId != 0);

        // checks if msg.sender owns the composable
        require(
            csnftContract.ownerToComposableId(_to) == _composableId,
            ">Unauthorized caller"
        );
        // fetch upgrading cost
        uint256 upgradeCost = csnftContract.getTierUpgradeCost(
            _upgradeToTierId
        );

        // check if owner has sufficient engagement points
        require(
            balanceOf(_to, 0) >= upgradeCost,
            "insufficient engagement points"
        );

        // check if owner has the last tier
        require(
            balanceOf(_to, _upgradeToTierId - 1) >= 1,
            ">Non-sequential tier upgrade error"
        );

        // if (_tierId == 1) {
        //     //first upgrade
        //     require(balanceOf(msg.sender, _tierId - 1) >= 1);
        // } else {
        //     require(
        //         (balanceOf(msg.sender, _tierId) >= _tierPriceArr[_tierId + 1])
        //     ); //
        // }
        burn(_to, 0, upgradeCost); // burn engagement tid 0

        _mint(address(csnftContract), _upgradeToTierId, 1, data);

        return true;
    }
    // implement function to mint | claim F(creators engagement ) at tokenId 0
}
