// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
///@dev handle Batch receiving function - !!!!

/// @notice create tier supply and attach to composable
import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

/* erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1)); */
contract snft1155UpgradePresetMinterPauser is
    ERC1155PresetMinterPauser,
    IERC1155Receiver
{
    // id 0 holds engagement F tokens;
    // if user sends 'sufficient' F tokens, upgrade tier of composable

    /// @dev add Tier upgrade logic to batch receive Add
    /// @param fromTokenId
    function _upgradeSNFT(
        address from, // where the tier is being trnsfered from
        uint256 composableId,
        address csnftContract,
        uint256 tierId,
        uint256 amount,
        bytes memory data
    ) private {
        require(tierId > 0 && amount == 1);

        // 0 address
        require(to != address(0), "ERC998: transfer to the zero address");
        // caller  of composable is owner of composable or is approved to transfer composable ,
        address operator = _msgSender();
        // require(
        //     ownerOf(fromTokenId) == operator ||
        //         isApprovedForAll(ownerOf(fromTokenId), operator),
        //     "ERC998: caller is not owner nor approved"
        // );

        // receive the F tiers

        safeTransferFrom(
            from,
            csnftContract,
            tierId,
            1, // amt == 1 only single transfer
            web3.utils.encodePacked(composableId)
        );
    }

    /// @todo handle recieving of F engagement token
    /// then

    /// @notice on receive F engagement  &token upgrade specified composable SNFT

    /// @dev  receive tokens & execute _upgradeSNFT

    /// @param

    /// @notice Handle the receipt of a single ERC1155 token type.
    /// @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
    /// This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
    /// This function MUST revert if it rejects the transfer.
    /// Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
    /// @param _operator  The address which initiated the transfer (i.e. msg.sender)
    /// @param _from      The address which previously owned the token
    /// @param _id        The ID of the token being transferred
    /// @param _value     The amount of tokens being transferred
    /// @param _data      Additional data with no specified format
    /// @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 composableId,
        uint256 amount,
        bytes memory data
    ) public virtual override returns (bytes4) {
        //on receive
        //  execute _
        // _upgradeSNFT(from , composableId, csnftContract, id, amount, data);
    }

    // rec
}
