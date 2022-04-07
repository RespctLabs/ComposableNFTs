// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./ERC1155TopDown.sol";

/**
 * @title ComposableParentERC721
 *
 * @author respect-club
 *
 * @notice Level-based Social NFTs, incentivizing fans through un-lockable perks & engagement.
 *
 */

/**
 * @dev {ERC998} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * {DEFAULT_ADMIN_ROLE , ADMIN_ROLE , MINTER_ROLE , PAUSER_ROLE}
 *
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 */

contract ComposableParentERC721 is
    Context,
    AccessControl,
    ERC1155TopDown,
    Pausable,
    ReentrancyGuard
{
    // EVENTS
=======
    event NFTMinted(address indexed NFTowner, uint256 indexed tokenId);
    event NFTMintPriceUpdated(uint256 indexed price);
    event TierUpgradePriceUpdated(
        uint256 indexed tierId,
        uint256 indexed price
    );
    event MaxSupplyUpdated(uint256 _value);

    using SafeMath for uint256;

    uint256 composableCount;

    uint256 public maxSupply = 100;
    uint256 public mintCost = 2 ether;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(uint256 => uint256) tierIdtoUpgradeCost;
    mapping(address => uint256) public ownerToComposableId;

    address payable owner;

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
     * account that deploys the contract.
     *
     * Token URIs will be autogenerated based on `baseURI` and their token IDs.
     * See {ERC721-tokenURI}.
     */
    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 firstUpgradeEngagementPoints // at 115 tierId 0
    ) public ERC1155TopDown(name, symbol, baseURI) {
        _setupRole(ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());

        owner = payable(msg.sender);
        composableCount = 0;
        tierIdtoUpgradeCost[1] = firstUpgradeEngagementPoints;
    }

    //PUBLIC GETTERS

    /**
     * @notice Fetches composable Id for an owner
     *
     * @param _owner composable NFT owner
     *
     */
    function getComposableId(address _owner) public view returns (uint256) {
        return ownerToComposableId[_owner];
    }

    /**
     * @notice Fetches total number of minted snft
     *
     *
     * @return uint256
     */
    function getComposableCount() public view returns (uint256) {
        return composableCount;
    }

    /**
     * @notice Fetches cost of minting snft of the creator
     *
     * @return uint256 mintCost
     *
     */

    function getMintCost() public view returns (uint256) {
        return mintCost;
    }

    /**
     * @notice Fetches amount of engagement points req to upgrade to tier(_tierId)
     *
     * @param _tierId tierId
     *
     * @return uint _cost
     *
     */
    function getTierUpgradeCost(uint256 _tierId) public view returns (uint256) {
        return tierIdtoUpgradeCost[_tierId];
    }


    /**
     * @notice Fetches current level of an snft
     *
     * @param _composableId composableId
     *
     * @param _childContract address of linked ComposableChildrenERC1155 contract
     *
     * @return uint cost
     *
     */
    function getLevel(uint256 _composableId, address _childContract)
        public
        view
        returns (uint256)
    {
        uint256 count = 0;
        for (uint256 i = 1; i < maxSupply; i++) {
            if (childBalance(_composableId, _childContract, i) == 1) {
                count += 1;
            } else {
                break;
            }
        }
        return count;
    }

    //PUBLIC SETTERS

    /**
     * @notice Sets Max limit of minting SNFT
     *
     * @dev ADMIN_ROLE
     *
     * @param _value new max supply value
     *
     *
     */

    function changeMaxSupply(uint256 _value) public {
        require(
            hasRole(ADMIN_ROLE, _msgSender()),
            "Unauthorized total supply setter"
        );
        maxSupply = value;
    }

    /**
     *@dev 1-tierPrice1 for first upgrade L0 to L1 ,2-tierPrice2
     *
     *@notice  set tier upgrade price
        maxSupply = _value;
        emit MaxSupplyUpdated(_value);
    }

    /**
     * @notice  Sets Tier upgrade price, indexed from 1.
     *
     * @dev ADMIN_ROLE
     *
     */

    function setTierUpgradeCost(uint256 _tierId, uint256 _cost) public {
        require(
            hasRole(ADMIN_ROLE, _msgSender()),
            "Unauthorized tier price setter"
        );

        tierIdtoUpgradeCost[_tierId] = _cost;
        emit TierUpgradePriceUpdated(_tierId, _cost);
    }

    /**
     * @notice Set cost of minting snft.
     *
     * @dev ADMIN_ROLE
     *
     * @param _cost minting cost ether/matic
     *
     */
    function setMintCost(uint256 _cost) public {
        require(hasRole(ADMIN_ROLE, _msgSender()));
        mintCost = _cost;
        emit NFTMintPriceUpdated(_cost);
    }

    }
    // CORE

    /**
     * @dev Creates a new token for `to`. The token URI autogenerated based on
     * the base URI passed at construction and the token ID.
     *
     * See {ERC721-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */

    // >one account can only mint one snft
    // We cannot just use balanceOf to create the new tokenId because tokens
    // can be burned (destroyed), so we need a separate counter.
    function mint() public payable virtual nonReentrant {
        require(msg.value == mintCost, "ERC721: must pay the mint cost");

        require(
            balanceOf(msg.sender) == 0,
            "ERC721: cannot own same token twice"
        );

        uint256 tokenId = composableCount + 1; //totalSupply()

        require(tokenId <= maxSupply, "ERC721: minting would cause overflow");

        _mint(msg.sender, tokenId);
        ownerToComposableId[msg.sender] = tokenId;
        composableCount = tokenId;
        payable(owner).transfer(msg.value);

        emit NFTMinted(msg.sender, tokenId);
    }

    /**
     * @dev Burns `tokenId`. See {ERC721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public virtual {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "ERC721PresetMinterPauserAutoId: must have pauser role to pause"
        );
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public virtual {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "ERC721PresetMinterPauserAutoId: must have pauser role to unpause"
        );
        _unpause();
    }

    /**
     * @dev See {ERC721-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(!paused(), "ERC721Pausable: token transfer while paused");

        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _beforeChildTransfer(
        address operator,
        uint256 fromTokenId,
        address to,
        address childContract,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        require(!paused(), "ERC998Pausable: child transfer while paused");

        super._beforeChildTransfer(
            operator,
            fromTokenId,
            to,
            childContract,
            ids,
            amounts,
            data
        );
    }
}