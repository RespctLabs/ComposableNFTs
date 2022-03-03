 Sūrya's Description Report

 Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| /home/waverune/respct-club/ERC998-ERC1155-TopDown/contracts/imports.sol | 515d82290d6aa23846ba1f5b51b5285bb941f31a |
| /home/waverune/respct-club/ERC998-ERC1155-TopDown/contracts/ERC998ERC1155TopDownPresetMinterPauser.sol | 952b3c02183196f2ed81ec16c68f7287d8a4e947 |
| /home/waverune/respct-club/ERC998-ERC1155-TopDown/contracts/IERC998ERC1155TopDown.sol | 2a8c52da49517bffe5bee63230d0aeaaf4bd3071 |
| /home/waverune/respct-club/ERC998-ERC1155-TopDown/contracts/ERC998ERC1155TopDown.sol | 12cd09bdc42bf80c63033ede868739e90ff963f5 |


 Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **ERC998ERC1155TopDownPresetMinterPauser** | Implementation | Context, AccessControl, ERC998ERC1155TopDown, Pausable |||
| └ | <Constructor> | Public ❗️ | 🛑  | ERC998ERC1155TopDown |
| └ | mint | Public ❗️ | 🛑  |NO❗️ |
| └ | burn | Public ❗️ | 🛑  |NO❗️ |
| └ | pause | Public ❗️ | 🛑  |NO❗️ |
| └ | unpause | Public ❗️ | 🛑  |NO❗️ |
| └ | _beforeTokenTransfer | Internal 🔒 | 🛑  | |
| └ | _beforeChildTransfer | Internal 🔒 | 🛑  | |
||||||
| **IERC998ERC1155TopDown** | Interface | IERC721, IERC1155Receiver |||
| └ | childContractsFor | External ❗️ |   |NO❗️ |
| └ | childIdsForOn | External ❗️ |   |NO❗️ |
| └ | childBalance | External ❗️ |   |NO❗️ |
| └ | safeTransferChildFrom | External ❗️ | 🛑  |NO❗️ |
| └ | safeBatchTransferChildFrom | External ❗️ | 🛑  |NO❗️ |
||||||
| **ERC998ERC1155TopDown** | Implementation | ERC721, ERC1155Receiver, IERC998ERC1155TopDown |||
| └ | <Constructor> | Public ❗️ | 🛑  | ERC721 |
| └ | childBalance | External ❗️ |   |NO❗️ |
| └ | childContractsFor | External ❗️ |   |NO❗️ |
| └ | childIdsForOn | External ❗️ |   |NO❗️ |
| └ | safeTransferChildFrom | Public ❗️ | 🛑  |NO❗️ |
| └ | safeBatchTransferChildFrom | Public ❗️ | 🛑  |NO❗️ |
| └ | onERC1155Received | Public ❗️ | 🛑  |NO❗️ |
| └ | onERC1155BatchReceived | Public ❗️ | 🛑  |NO❗️ |
| └ | _receiveChild | Internal 🔒 | 🛑  | |
| └ | _removeChild | Internal 🔒 | 🛑  | |
| └ | _beforeChildTransfer | Internal 🔒 | 🛑  | |
| └ | _asSingletonArray | Private 🔐 |   | |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
