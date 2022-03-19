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
        csnftContract = ERC998ERC1155TopDownPresetMinterPauser(
            _csnftContractAdr
        );
    }

    // function _mintTier(CSNFTContract csnftContract, uint tierId, bytes data ) private {
    //     uint256 amt = 1;
    //     _mint(csnftContract.address, tierId,1, data);
    // }

    /// @notice upgrade user tier
    /// @dev Explain to a developer any extra details

    function upgradeSNFT(
        uint256 _composableId,
        uint256 _tierId,
        bytes calldata data // web3.utils.encodePacked(composableId)
    ) external payable {
        //add tier checks

        require(
            csnftContract.childBalance(_composableId, address(this), _tierId) ==
                0
        );

        require(_tierId != 0 && (balanceOf(msg.sender, _tierId - 1) == 1));
        // 0 address
        // require(
        //     csnftContract != address(0),
        //     "ERC998: transfer to the zero address"
        // );
        // caller  of composable is owner of composable or is approved to transfer composable ,

        _mint(address(csnftContract), _tierId, 1, data);
    }

    // implement function to mint | claim F(creators engagement ) at tokenId 0
}
