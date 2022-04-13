# ERC998 composable ERC1155 Top Down
An ERC721 (non fungible-token) that owns ERC1155 (multi-token) from other contracts.


# Contracts
ComposableParentERC721 : SNFT Minter Pauser
ComposableChildrenERC1155 : Tier Upgrade Minter Pauser

Oracle contract : off chain requests to APIconsumer contract via external adapter


### FLOW
   * Chainlink State:-
    - ChainLink token address :  
    - ChainLink reques Job id :
Make sure the contract addresses are on the same network
   Deploy Contracts
   -npx hardhat run --network <network> scripts/deploy.js



Deploying 'ComposableParentERC721'
   --------------------------------------------------
   > transaction hash:    0x9fff4f8e2ec17000cc5ad6985bffe2018c0c1f33ebab780786a33ace429a1785
   > Blocks: 3            Seconds: 13
   > contract address:    0x079d969B3F91A3b051eDaD2e1DA764186F1666bb
https://mumbai.polygonscan.com/address/0x079d969b3f91a3b051edad2e1da764186f1666bb#code

Deploying 'ComposableChildrenERC1155'
   ------------------------------------------------
   > transaction hash:    0xfc09a489f2499cc9fb427a585719c58b4fa4870e61260db613c1734fcb1152b2
   > Blocks: 2            Seconds: 13
   > contract address:    0x5aA35F537e9e62454Bd3F6E9823BB17A6E3B16c7
https://mumbai.polygonscan.com/address/0x5aA35F537e9e62454Bd3F6E9823BB17A6E3B16c7#writeContract