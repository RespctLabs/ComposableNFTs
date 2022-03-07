// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

/// @notice create tier supply and attach to composable
/// receive MATIC and mint tier to msg.sender
///             must own cSNFT

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details

import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";

// contract snft1155UpgradePresetMinterPauser is ERC1155PresetMinterPauser {
//     /// @notice attaches minted tier1155 to 998 composable
//     ///
//     /// @dev
//     /// @param csnft composable contract address
//     /// erc1155.safeTransferFrom(admin, SNFTerc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
//     /// mint(admin, multiTokenTier2, multiTokenMaxSuply, "0x")
//     /// tierIds 1,2,3, ...

//     /// @notice Explain to an end user what this does
//     /// @dev Explain to a developer any extra details
//     /// @param from erc1155 tierToken holder's address
//     /// @param csnftContract address
//     /// @param data arbitrary , for now
//     /// @return Documents the return variables of a contract’s function state variable
//     /// @inheritdoc	Copies all missing tags from the base function (must be followed by the contract name)
//     function upgradeSNFT(
//         address _from,
//         address csnftContract,
//         uint256 tierId,
//         uint256 composableId
//         bytes data,
//     ) public payable {
//         //receive F token

//         //checks cSNFT is held by msg.sender
//         //
//         mint(this, tierId, 1, data); // supply

//         _upgradeSNFT()
//     }

//     /// @notice Explain to an end user what this does
//     /// @dev Explain to a developer any extra details
//     /// @param Documents a parameter just like in doxygen (must be followed by parameter name)
//     /// @return Documents the return variables of a contract’s function state variable
//     /// @inheritdoc	Copies all missing tags from the base function (must be followed by the contract name)
//     function _upgradeSNFT() private {
//         safeTransferFrom(
//             _from,
//             csnft,
//             tierId,
//             1, // only single transfer
//             web3.utils.encodePacked(composableId)
//         );
//     }

//     // rec
