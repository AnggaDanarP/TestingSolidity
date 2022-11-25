// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./metadata/OnChainMetadata.sol";

contract NftParcelMetaverse is ERC721, OnChainMetadata {

    string public image;
    uint256 tokenCounter;

    bytes32 constant key_token_size = "size";
    bytes32 constant key_token_type = "type";
    bytes32 constant key_token_map = "map";

    string constant public description = "Testing NFT for minting metaverse land and i hope all the metadata can see in open fucking sea";
    constructor(string memory name, string memory symbol, string memory _image) ERC721(name, symbol) {
            image = _image; // set the image for the NFT
            tokenCounter = 1;

            _addValue(_contractMetadata, key_contract_name, abi.encode("Testing NFT Parcel metadata"));
            _addValue(_contractMetadata, key_contract_description, abi.encode("Simple Test for NFT On-Chain Metadata"));
            _addValue(_contractMetadata, key_contract_image, abi.encode(createSVG()));
            _addValue(_contractMetadata, key_contract_external_link, abi.encode("https://github.com/DanielAbalde/NFT-On-Chain-Metadata"));
            _addValue(_contractMetadata, key_contract_seller_fee_basis_points, abi.encode(500));
            _addValue(_contractMetadata, key_contract_fee_recipient, abi.encode(_msgSender()));
        }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _createTokenURI(tokenId);
    }

    function contractURI() public view virtual returns (string memory) {
        return _createContractURI();
    }

    function createSVG() public view returns (string memory) {
        return string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(bytes(string(abi.encodePacked(image))))));
    }

    function claimNftParcel(string memory _size, string memory _type, string memory _map) public {

        _setValue(tokenCounter, key_token_name, abi.encode(string(abi.encodePacked(name(), ' #', Strings.toString(tokenCounter)))));
        _setValue(tokenCounter, key_token_description, abi.encode(description));
        _setValue(tokenCounter, key_token_image, abi.encode(image));
        _setValue(tokenCounter, key_token_size, abi.encode(_size));
        _setValue(tokenCounter, key_token_type, abi.encode(_type));
        _setValue(tokenCounter, key_token_map, abi.encode(_map));

        bytes[] memory trait_types = new bytes[](3);
        bytes[] memory trait_values = new bytes[](3);
        bytes[] memory trait_display = new bytes[](3);
        trait_types[0] = abi.encode("size");
        trait_types[1] = abi.encode("type");
        trait_types[2] = abi.encode("map");
        trait_values[0] = abi.encode(_size);
        trait_values[1] = abi.encode(_type);
        trait_values[2] = abi.encode(_map);
        trait_display[0] = abi.encode("");
        trait_display[1] = abi.encode("");
        trait_display[2] = abi.encode("");
        _setValues(tokenCounter, key_token_attributes_trait_type, trait_types);
        _setValues(tokenCounter, key_token_attributes_trait_value, trait_values);
        _setValues(tokenCounter, key_token_attributes_display_type, trait_display);

        /**
         * trying to minting
         */
        _safeMint(_msgSender(), tokenCounter, "");
        tokenCounter++;
    }
}
