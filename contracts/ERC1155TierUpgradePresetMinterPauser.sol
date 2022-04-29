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

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

/*
    erc1155.mint(admin, multiTokenTier0, multiTokenMaxSuply, "0x");
    erc1155.safeTransferFrom(admin, erc998.address, multiTokenTier0, 1, web3.utils.encodePacked(composable1));
*/
contract ERC1155TierUpgradePresetMinterPauser is ERC1155PresetMinterPauser, ChainlinkClient {
        using Chainlink for Chainlink.Request;
        event urlCreated(string indexed url);
        address private oracle;
        bytes32 private jobId;
        uint256 private fee;
        mapping (bytes32 => uint256) requestResult; 
        mapping (address => uint[]) userRequests; 
        string constant baseUrl = "https://respctbot.herokuapp.com/address";


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
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        oracle = 0x0bDDCD124709aCBf9BB3F824EbC61C87019888bb;
        jobId = "2bb15c3f9cfc4336b95012872ff05092";
        fee = 0.01 * 10 ** 18; // (Varies by network and job)
    }

    function submitRequest(string memory url ) public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", url);
        request.add("path", "status"); // Chainlink nodes 1.0.0 and later support this format

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 status) public recordChainlinkFulfillment(_requestId)
    {
        requestResult[_requestId] = status; 
    }

    function createRequest() public returns (uint) {
        string memory url = string(abi.encodePacked(baseUrl, '/', "0xefdC1A6e05e1737F2cfD26BB0f72D5B7FBaDD176"));
        uint requestId = uint(submitRequest(url));
        userRequests[msg.sender].push(requestId);
        return requestId;  
    }
    function getRequestResult(uint _requestId) public view returns (uint256) {
        return requestResult[bytes32(_requestId)];
    } 
     function getMyRequestIDs() public view returns (uint[] memory) {
        return userRequests[msg.sender];
    }

    /// claimF engagement points
    //function claim(){}

    /// @notice upgrade user tier
    /// @dev fetch curent tier of msg.sender
    /// msg.value user sends
    function upgradeSNFT(
        uint256 _composableId,
        uint256 _upgradeToTierId, // upgrade to
        bytes calldata data // web3.utils.encodePacked(composableId)
    ) external payable {
        //add tier checks  if tierId =1 bal(t-1) == 1
        // at t=0 bal(0) >= _FengagementPOints
        require(_upgradeToTierId != 0);

        uint256 upgradeCost = csnftContract.getTierPrice(_upgradeToTierId);
        require(balanceOf(msg.sender, 0) >= upgradeCost); // have enough Engagment points at
        require(balanceOf(msg.sender, _upgradeToTierId - 1) >= 1);

        // if (_tierId == 1) {
        //     //first upgrade
        //     require(balanceOf(msg.sender, _tierId - 1) >= 1);
        // } else {
        //     require(
        //         (balanceOf(msg.sender, _tierId) >= _tierPriceArr[_tierId + 1])
        //     ); //
        // }
        burn(msg.sender, 0, upgradeCost); // burn engagement tid 0

        _mint(address(csnftContract), _upgradeToTierId, 1, data);
    }

    // implement function to mint | claim F(creators engagement ) at tokenId 0
}
