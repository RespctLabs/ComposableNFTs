// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
///@dev handle Batch receiving function - !!!!

/// @notice create tier supply and attach to composable
import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";

/*
    erc1155.mint(admin, multiTokenTier0, multiTokenMaxSuply, "0x");
    erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));

*/
contract ERC1155TierUpgradePresetMinterPauser is ERC1155PresetMinterPauser {
    bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))

    constructor(string memory tierUri)
        public
        ERC1155PresetMinterPauser(tierUri)
    {}

    // function _mintTier(CSNFTContract csnftContract, uint tierId, bytes data ) private {
    //     uint256 amt = 1;
    //     _mint(csnftContract.address, tierId,1, data);
    // }

    function upgradeSNFT(
        address from, // where the tier is being trnsfered from
        address csnftContract,
        uint256 tierId,
        bytes calldata data // web3.utils.encodePacked(composableId)
    ) external payable {
        //add tier checks

        require(tierId > 0 || balanceOf(msg.sender, tierId - 1) == 1);

        // 0 address
        require(
            csnftContract != address(0),
            "ERC998: transfer to the zero address"
        );
        // caller  of composable is owner of composable or is approved to transfer composable ,
        address operator = _msgSender();

        _mint(csnftContract, tierId, 1, data);
    }
}
