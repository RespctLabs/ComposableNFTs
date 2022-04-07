// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";
// import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "./ComposableParentERC721.sol";

/**
 *
 * @title ComposableChildrenERC1155
 *
 * @author respect-club
 *
 * @notice receives Engagement tokens and attaches tier to composableParentERC721 (csnft)
 *
 */
contract ComposableChildrenERC1155 is
    ERC1155PresetMinterPauser,
    ChainlinkClient
{
    //EVENTS
    event upgraded(address indexed _owner);
    event RequestEngagementStatusFulfilled(
        bytes32 indexed requestId,
        uint256 indexed status
    );

    //STATE
    using SafeMath for uint256;
    using Chainlink for Chainlink.Request;

    uint256 public requestStatus; //jersey

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))

    ComposableParentERC721 csnftContract;

    // mapping (address => mapping (address => uint256)) private _allowances;

    mapping(address => uint256) public ownerToTierId;

    mapping(address => mapping(uint256 => bool))
        private _ownerToUpgradeInitiated;

    /**
     *
     * @notice composable parent contract is deployed and linked to this
     *
     * @param _csnftContractAdr deployed composable parent contract address
     */
    constructor(string memory tierUri, address _csnftContractAdr)
        public
        ERC1155PresetMinterPauser(tierUri)
    {
        require(
            _csnftContractAdr != address(0),
            "ERC998: transfer to the zero address"
        );

        csnftContract = ComposableParentERC721(_csnftContractAdr);
        setPublicChainlinkToken();
        oracle = 0x778E59137Af4C3272A060296cb01b4d0D7455Ca2; //add addr
        jobId = ""; //add
        fee = 0.1 * 10**18; // (Varies by network and job)
    }

    //PUBLIC GETTERS
    /**
     * @notice get latest child id of owner
     *
     * @param _owner address
     *
     */
    function getLatestTierId(address _owner) public returns (uint256) {
        // uint256[] s arr = childIdsForOn(_composableId, tierContract);
        return ownerToTierId[_owner];
    }

    /**
     * @notice checks if owner has current tier
     *
     * @param _to  owner
     *
     * @param _tierId tid
     *
     * @return bool
     */
    function hasTier(address _to, uint256 _tierId) public returns (bool) {
        // uint256[] s arr = childIdsForOn(_composableId, tierContract);
        return _ownerToUpgradeInitiated[_to][_tierId];
    }

    //PRIVATE SETTERs
    /**
     * @notice updates owners latest tier id
     *
     * @param _to receiving address
     *
     * @param _latestTierId updated tierId
     *
     */
    function _setOwnerTierId(address _to, uint256 _latestTierId) private {
        ownerToTierId[_to] = _latestTierId;
        _ownerToUpgradeInitiated[_to][_latestTierId] = true;
    }

    //CORE
    /**
     * @notice mints enagagement point onlyMinterRole
     *
     * @param _to csnftContract Address
     *
     * @param _amount of F engagement  points
     *
     * @param _data web3.utils.encodePacked(composableId)
     */
    function mintEngagementPoints(
        address _to,
        uint256 _amount,
        bytes memory _data
    ) public {
        // require(
        //     hasRole(MINTER_ROLE, _msgSender()),
        //     "ERC1155TUMP unauthorized engagement minter"
        // );

        _mint(_to, 0, _amount, _data);
    }

    /**
     * @notice upgrade user tier
     *
     * @dev fetch curent tier of msg.sender
     *
     * @param _composableId composable id of owner
     *
     * @param _upgradeToTierId new tier ID
     *
     * @param _data  web3.encodePacked
     *
     * @return bool
     *
     */
    function upgradeSNFT(
        uint256 _composableId,
        uint256 _upgradeToTierId,
        bytes calldata _data // web3.utils.encodePacked(composableId)
    ) external returns (bool) {
        //add tier checks  if tierId =1 bal(t-1) == 1
        // at t=0 bal(0) >= _FengagementPOints
        require(_upgradeToTierId != 0, ">Incorrect tierId, L0 ");
        // checks if _to owns the composable
        require(
            csnftContract.getComposableId(msg.sender) == _composableId,
            ">Unauthorized caller"
        );

        // fetch upgrading cost
        uint256 upgradeCost = csnftContract.getTierUpgradeCost(
            _upgradeToTierId
        );
        require(
            balanceOf(msg.sender, 0) >= upgradeCost,
            "> insufficient engagement points"
        );
        require(hasTier(msg.sender, _upgradeToTierId) == false);

        if (_upgradeToTierId == 1) {
            require(getLatestTierId(msg.sender) != 1, "already upgraded");
        } else {
            require(
                getLatestTierId(msg.sender) == _upgradeToTierId - 1,
                ">Non-sequential tier upgrade error"
            );
            require(
                hasTier(msg.sender, _upgradeToTierId - 1) == true,
                ">>Non-sequential tier upgrade error"
            );
        }

        // check if owner has sufficient engagement points

        burn(msg.sender, 0, upgradeCost); // burn engagement tid 0

        _mint(address(csnftContract), _upgradeToTierId, 1, _data);
        _setOwnerTierId(msg.sender, _upgradeToTierId);

        return true;
    }

    //chainlink requests

    function requestEngagementStatus(
        address _oracle,
        string memory _jobId,
        string memory _url,
        uint256 _composableId
    ) public {
        // ccheck if msg.senderr owns composable721
        uint256 cid = csnftContract.getComposableId(msg.sender);
        require(
            csnftContract.getComposableId(msg.sender) == _composableId,
            ">Unauthorized caller"
        );

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillEngagementStatus.selector
        );
        // req.add("caller", msg.sender);

        req.add(
            "get",
            "https://respctbot.herokuapp.com/address/0xb35a91f1C23c1B36257Fa89fDA70113be57962Cd"
        );
        req.add("path", "status");

        sendChainlinkRequestTo(_oracle, req, fee);
    }

    // {"message":"success","status":200,"value":false}
    function fulfillEngagementStatus(bytes32 _requestId, uint256 _requestStatus)
        public
        recordChainlinkFulfillment(_requestId)
    {
        requestStatus = _requestStatus;
        if (_requestStatus == 400) {
            //return false
        } else if (_requestStatus == 200) {
            // _mint(_to, 0, _amt, "0x0");
        }
        emit RequestEngagementStatusFulfilled(_requestId, _requestStatus);
    }

    function stringToBytes32(string memory source)
        private
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }
}
