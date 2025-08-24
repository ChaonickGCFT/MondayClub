// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * ANTI-SUNDAY — founder sigil NFT (OZ v5 compatible)
 * - Owner-only minting
 * - Owner can update tokenURI
 * - Default tokenURI stored on-chain
 */
contract AntiSundayNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId = 0;

    /// Default metadata JSON (this JSON should have an HTTPS image URL inside)
    string public defaultTokenURI =
        "ipfs://bafkreifjz4nkr2as26yote6odvtgg6xud5rtqpizyecoenkd5latov56qy";

    /// OZ v5 Ownable requires passing the initial owner
    constructor()
        ERC721("ANTI-SUNDAY", "ANTI")
        Ownable(msg.sender)
    {}

    // ------------------------
    //        MINTING
    // ------------------------

    /// Mint using the default metadata URI
    function mint(address to) public onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, defaultTokenURI);
        nextTokenId++;
    }

    /// Mint with a custom metadata URI
    function mintWithURI(address to, string memory uri) public onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        nextTokenId++;
    }

    /// Update tokenURI for an existing token (owner-only)
    function updateTokenURI(uint256 tokenId, string memory newURI) public onlyOwner {
        // OZ v5 removed _exists; use _ownerOf or _requireOwned
        require(_ownerOf(tokenId) != address(0), "ANTI: token does not exist");
        _setTokenURI(tokenId, newURI);
    }

    /// Update the default tokenURI used by `mint()`
    function setDefaultTokenURI(string memory newDefault) public onlyOwner {
        defaultTokenURI = newDefault;
    }
}
