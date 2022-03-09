// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

/// @notice create tier supply and attach to composable
import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";

contract snft1155UpgradePresetMinterPauser is ERC1155PresetMinterPauser {
    // id 0 holds engagement F tokens;
    // if user sends 'sufficient' F tokens, upgrade tier of composable

    /// @dev add Tier upgrade logic to batch receive Add
    function _upgradeSNFT(
        uint256 fromTokenId,
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
            _from,
            csnftContract,
            tierId,
            1, // only single transfer
            web3.utils.encodePacked(composableId)
        );
    }

    /// @todo handle recieving of F engagement token
    /// then

    /// @notice on receive F engagement  &token upgrade specified composable SNFT

    /// @dev  receive tokens & execute _upgradeSNFT

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 composableId,
        uint256 amount,
        bytes memory data
    ) public virtual override returns (bytes4) {
        //on eceive
        //  execute _
        // _upgradeSNFT(composableId, csnftContract, id, amount, data);
    }

    // rec
}
