// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
///@dev handle Batch receiving function - !!!!

/// @title ERC1155TUMP creates tier supply and attaches tier to composable
/// @author respect-club
/// @notice receives Engagement tokens and attaches tier to composable ERC998

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

import "@openzeppelin/contracts-upgradeable/presets/ERC1155PresetMinterPauserUpgradeable.sol";
// import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155HolderUpgradeable.sol";
import "./ERC998ERC1155TopDownPresetMinterPauserUpgradeable.sol";

contract ERC1155TierUpgradePresetMinterPauserUpgradeable is
    Initializable,
    ERC1155PresetMinterPauserUpgradeable
{
    using SafeMathUpgradeable for uint256;
    bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))

    ERC998ERC1155TopDownPresetMinterPauserUpgradeable csnftContract;
    mapping(address => uint256) public ownerToTierId;

    mapping(address => bool) private _ownerToUpgradeInitiated;

    /// @notice csnft contract is deployed and linked to ERC1155TUMP
    /// @param _csnftContractAdr deployed csnft contract

    function initialize(string memory tierUri, address _csnftContractAdr)
        public
        initializer
    {
        __ERC1155PresetMinterPauser_init(tierUri);
        require(
            _csnftContractAdr != address(0),
            "ERC998: transfer to the zero address"
        );

        csnftContract = ERC998ERC1155TopDownPresetMinterPauserUpgradeable(
            _csnftContractAdr
        );
    }

    function getLatestTierId(address _to) public returns (uint256) {
        // uint256[] s arr = childIdsForOn(_composableId, tierContract);
        return ownerToTierId[_to];
    }

    /// implement claimF engagement points
    //function claim(){}
    /// @notice mints enagagement point onlyMinterRole
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
    /// @param _to  the owner of the  snft to be upgraded

    function upgradeSNFT(
        address _to, //  a/c of owner of snft
        uint256 _composableId,
        uint256 _upgradeToTierId,
        bytes calldata data // web3.utils.encodePacked(composableId)
    ) external returns (bool) {
        //add tier checks  if tierId =1 bal(t-1) == 1
        // at t=0 bal(0) >= _FengagementPOints
        require(_upgradeToTierId != 0);

        // checks if _to owns the composable
        require(
            csnftContract.ownerToComposableId(_to) == _composableId,
            ">Unauthorized caller"
        );

        // fetch upgrading cost
        uint256 upgradeCost = csnftContract.getTierUpgradeCost(
            _upgradeToTierId
        );
        require(
            balanceOf(_to, 0) >= upgradeCost,
            "> insufficient engagement points"
        );

        if (_upgradeToTierId == 1) {
            require(
                balanceOf(_to, _upgradeToTierId) == upgradeCost,
                ">First Upgrade"
            ); //handle
        } else {
            require(
                balanceOf(_to, _upgradeToTierId - 1) == 1,
                ">Non-sequential tier upgrade error"
            );
        }
        require(balanceOf(_to, _upgradeToTierId) == 0, "tier already exists");

        // check if owner has sufficient engagement points

        burn(_to, 0, upgradeCost); // burn engagement tid 0

        _mint(address(csnftContract), _upgradeToTierId, 1, data);

        // csnftContract.incrementTierId(_to, _upgradeToTierId);
        return true;
    }
    // implement function to mint | claim F(creators engagement ) at tokenId 0
}
