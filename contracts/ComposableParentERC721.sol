// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./ERC1155TopDown.sol";

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
    using SafeMath for uint256;

    uint256 composableCount;
    uint256 public maxSupply = 100;
    uint256 public mintCost = 2 ether;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(uint256 => uint256) tierIdtoUpgradeCost; // 1,2,3 ...  cost to upgrade to tier1, tier2, tier3...
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
        uint256 _fEngagementPoints // at 115 tierId 0
    ) public ERC1155TopDown(name, symbol, baseURI) {
        _setupRole(ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());

        owner = payable(msg.sender);
        composableCount = 0;
        tierIdtoUpgradeCost[1] = _fEngagementPoints;
    }

    /// @notice  set tier upgrade price
    /// @dev 1-tierPrice1 for first upgrade L0 to L1 ,2-tierPrice2
    function setTierUpgradeCost(uint256 _tierId, uint256 _cost) public {
        require(
            hasRole(ADMIN_ROLE, _msgSender()),
            "Unauthorized tier price setter"
        );

        tierIdtoUpgradeCost[_tierId] = _cost;
    }

    /// returns uint price of tier upgrade
    function getTierUpgradeCost(uint256 _tierId) public view returns (uint256) {
        uint256 cost = tierIdtoUpgradeCost[_tierId];
        return cost;
    }

    // function incrementTierId(address _to) private {
    //     ownerToTierId[_to] = _latestTierId;
    // }

    function getComposableId(address _owner) public view returns (uint256) {
        uint256 cid = ownerToComposableId[_owner];
        return cid;
    }

    function getComposableCount() public view returns (uint256) {
        return composableCount;
    }

    function isUpgradeable(uint256 cid) public returns (bool) {
        // msg.sender is owner of the composable
        // has enough engagement points at tierId = 0
        // has sufficient engagement points at tid-1
        require(balanceOf(msg.sender) == 1);
    }

    function getMintCost() public view returns (uint256) {
        return mintCost;
    }

    function setMintCost(uint256 _cost) public {
        require(hasRole(ADMIN_ROLE, _msgSender()));
        mintCost = _cost;
    }

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

    /// admin would be marketplace

    // >one account can only mint once
    function mint() public payable virtual nonReentrant {
        // require(
        //     hasRole(MINTER_ROLE, _msgSender()),
        //     "ERC721: must have minter role to mint"
        // );
        require(msg.value == mintCost, "ERC721: must pay the mint cost");
        require(
            balanceOf(msg.sender) == 0,
            "ERC721: cannot own same token twice"
        );

        uint256 tokenId = composableCount + 1; //totalSupply()

        require(tokenId <= maxSupply, "ERC721: minting would cause overflow");
        // require()); // implement safemath

        // // We cannot just use balanceOf to create the new tokenId because tokens
        // // can be burned (destroyed), so we need a separate counter.
        _mint(msg.sender, tokenId);
        ownerToComposableId[msg.sender] = tokenId;
        // ownerToTierId[to] = 0; // level0
        composableCount = tokenId;
        payable(owner).transfer(msg.value);

        emit NFTMinted(ownerToComposableId[msg.sender]);
    }

    function getLevel(uint256 composableId, address childContract)
        public
        view
        returns (uint256)
    {
        uint256 count = 0;
        for (uint256 i = 1; i < maxSupply; i++) {
            if (childBalance(composableId, childContract, i) == 1) {
                count += 1;
            } else {
                break;
            }
        }
        return count;
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

    function changeMaxSupply(uint256 value) public {
        require(
            hasRole(ADMIN_ROLE, _msgSender()),
            "Unauthorized total supply setter"
        );
        maxSupply = value;
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

    event NFTMinted(uint256 indexed tokenId);
}
