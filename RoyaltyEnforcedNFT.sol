// SPDX-License-Identifier: MIT

// Author: zac@juicelabs.io

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RoyaltyEnforcedNFT is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint256 public immutable royaltyBips;
    mapping(uint256 => uint256) public tokenListingPrices;

    constructor(uint256 _royaltyBips) ERC721("RoyaltyEnforcedNFT", "REN") {
        royaltyBips = _royaltyBips;
    }

    function mint() public payable returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);

        _tokenIds.increment();
        return newItemId;
    }

    /**
     * TRANSFERS CAN ONLY OCCUR THROUGH EXPLICIT LISTING FLOW
     */
    function listToken(uint256 tokenId, uint256 price) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Cannot list without owning the token"
        );
        require(price != 0, "The listing price cannot be zero");

        tokenListingPrices[tokenId] = price;
    }

    function removeListing(uint256 tokenId) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Cannot list without owning the token"
        );
        tokenListingPrices[tokenId] = 0;
    }

    function buyToken(uint256 tokenId) public payable {
        address owner = ownerOf(tokenId);
        uint256 listingPrice = tokenListingPrices[tokenId];
        require(msg.sender != owner, "Cannot purchase own token");
        require(listingPrice != 0, "Token is not listed for sale");

        // could overflow revert with enormous prices, practically unlikely
        uint256 royaltyPrice = (listingPrice * royaltyBips) / 10000;

        require(
            msg.value > (listingPrice + royaltyPrice),
            "Insufficient funds"
        );

        // clear listing
        tokenListingPrices[tokenId] = 0;

        // push payment to lister. royalty price remains in the contract
        payable(owner).transfer(listingPrice);

        // transfer token
        _safeTransfer(owner, msg.sender, tokenId, "");
    }

    /**
     * Disable explicit transfers
     */

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert("No explicit transfers in royalty enforced NFTs");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        revert("No explicit transfers in royalty enforced NFTs");
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert("No explicit transfers in royalty enforced NFTs");
    }

    /**
     * REMOVE ALL APPROVAL FUNCTIONALITY
     */

    function approve(address to, uint256 tokenId) public virtual override {
        revert("No approvals in royalty enforced NFT");
    }

    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        revert("No approvals in royalty enforced NFT");
    }
}
