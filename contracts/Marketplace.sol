//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

struct Sale {
    uint256 tokenId;
    uint256 sellingPrice;
    address seller;
    uint256 sellId;
}

contract Marketplace is ERC1155Holder {

    uint256 private _sellId;

    IERC1155 public funToken;
    IERC20 public currencyToken;
    IERC2981 public funTokenRoyalty;
    mapping(uint256 => Sale) sales;

    constructor(address funTokenContract, address currency) {
        _sellId = 1; // initial id
        funToken = IERC1155(funTokenContract);
        funTokenRoyalty = IERC2981(funTokenContract);
        currencyToken = IERC20(currency);
    }

    function sell(uint256 tokenId, uint256 sellPrice) public returns (uint256) {
        address owner = msg.sender;

        Sale memory newSale = Sale(tokenId, sellPrice, owner, _sellId);

        sales[_sellId] = newSale;
        funToken.safeTransferFrom(owner, address(this), tokenId, 1, "");

        _sellId++;
        return newSale.sellId;
    }

    function buy(uint256 saleId) public {
        address buyer = msg.sender;

        Sale memory saleInfo = sales[saleId];
        (address royaltyOwner, uint256 royalty) = funTokenRoyalty.royaltyInfo(saleInfo.tokenId, saleInfo.sellingPrice);

        // console.log('royalty', royalty);

        // check balance of buyer
        uint256 bal = currencyToken.balanceOf(buyer);
        require(bal > saleInfo.sellingPrice + royalty, 'Not enough balance');

        // transfer the selling price
        funToken.safeTransferFrom(address(this), buyer, saleInfo.tokenId, 1, "");
        currencyToken.transferFrom(buyer, saleInfo.seller, saleInfo.sellingPrice);
        currencyToken.transferFrom(buyer, royaltyOwner, royalty);

        delete sales[saleId];
    }

    function getSaleById(uint saleId) public view returns(Sale memory)  {
        return sales[saleId];
    }
}