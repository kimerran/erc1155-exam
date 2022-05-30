//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FunToken is ERC1155, ERC2981 {
    string constant _baseUri  = 'https://ipfs.io/sample/';
    address public royaltyOwner;

    constructor(address _royaltyOwner) ERC1155("") {
        _mint(msg.sender, 1, 1, "");
        _mint(msg.sender, 2, 1, "");
        _mint(msg.sender, 3, 1, "");

        royaltyOwner = _royaltyOwner;

        setTokenRoyalty(1, royaltyOwner, 1000); // 10%
        setTokenRoyalty(2, royaltyOwner, 1000);
        setTokenRoyalty(3, royaltyOwner, 1000);
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                _baseUri,
                Strings.toString(_tokenid),".json"
            )
        );
    }

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) public {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}