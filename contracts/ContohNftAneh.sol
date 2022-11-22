// SPDX-License-Identifier: UNDIFINED

pragma solidity >=0.8.12 <=0.9.0;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Whatever is ERC721, ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private pic;
    
    struct Attr {
        string name;
        string blockchainSelection;
        string size;
        string _type;
        string map;
    }

    mapping(uint256 => Attr) public metadataMetaverse;

    constructor(
        string memory _name, 
        string memory _symbol, 
        string memory _metadata) 
    ERC721(_name, _symbol) Ownable() {
        setPic(_metadata);
    }

    function toString(uint256 value) private pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return '0';
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function getPic() private view returns (string memory) {
        string memory data = pic;
        return data;
    } 

    function setPic(string memory _pic) public onlyOwner {
        pic = _pic;
    }

    function getName(uint256 tokenId) private view returns (string memory) {
        return metadataMetaverse[tokenId].name;
    } 

    function getBlockchain(uint256 tokenId) private view returns (string memory) {
        return metadataMetaverse[tokenId].blockchainSelection;
    }

    function getSize(uint256 tokenId) private view returns (string memory) {
        return metadataMetaverse[tokenId].size;
    }

    function getType(uint256 tokenId) private view returns (string memory) {
        return metadataMetaverse[tokenId]._type;
    }

    function getMap(uint256 tokenId) private view returns (string memory) {
        return metadataMetaverse[tokenId].map;
    }

    function _baseURI(uint256 tokenId) public view returns (string memory) {
        // string[10] memory i;
        // i[0] = '{\n\t\"name\": \"Metaverse Whatever Testing\",\n';
        // i[1] = '\t\"description\": \"Only demo for minting tokens.\",\n';
        // i[2] = string.concat('\t\"image\": \"', getPic(), '\",\n');
        // i[3] = '\t\"attributes\": [\n';
        // i[4] = string.concat('\t\t{\n\t\t\t\"trait_type\": \"Name\",\n\t\t\t\"value\": \"', metadataMetaverse[tokenId].name, '\"\n\t\t},\n');
        // i[5] = string.concat('\t\t{\n\t\t\t\"trait_type\": \"Blockchain\",\n\t\t\t\"value\": \"', metadataMetaverse[tokenId].blockchainSelection, '\"\n\t\t},\n');
        // i[6] = string.concat('\t\t{\n\t\t\t\"trait_type\": \"Size\",\n\t\t\t\"value\": \"', metadataMetaverse[tokenId].size, '\"\n\t\t},\n');
        // i[7] = string.concat('\t\t{\n\t\t\t\"trait_type\": \"Type\",\n\t\t\t\"value\": \"', metadataMetaverse[tokenId]._type, '\"\n\t\t},\n');
        // i[8] = string.concat('\t\t{\n\t\t\t\"trait_type\": \"Map\",\n\t\t\t\"value\": \"', metadataMetaverse[tokenId].map, '\"\n\t\t}\n');
        // i[9] = '\t]\n}';
        
        // // concat all the array string
        // string memory output = string.concat(i[0], i[1], i[2], i[3], i[4]);
        // output = string.concat(output, i[5], i[6], i[7], i[8]);
        // output = string.concat(output, i[9]);


        //return output;

        string[11] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getName(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getBlockchain(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = getSize(tokenId);

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = getType(tokenId);

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = getMap(tokenId);

        parts[10] = '</text><text x="10" y="120" class="base">';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]));
        output = string(abi.encodePacked(output, parts[6], parts[7], parts[8], parts[9], parts[10]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', toString(tokenId), '", "description": "Simple testing NFT for metaverse On-Chain.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;

    }

    function addOnMetadata(
        uint256 _tokenId,
        string memory _nameMetaverse,
        string memory _blockchainSelection,
        string memory _metaverseSize,
        string memory _metaverseType,
        string memory _metaverseMap) 
    private onlyOwner {
            Attr memory newMetadata = Attr({
                name : _nameMetaverse,
                blockchainSelection : _blockchainSelection,
                size : _metaverseSize,
                _type : _metaverseType,
                map : _metaverseMap
            });
            metadataMetaverse[_tokenId] = newMetadata;
        }

    function claimWhatever(
        string memory _name, 
        string memory _blockchain, 
        string memory _size,
        string memory _type,
        string memory _map) 
    public nonReentrant {
        uint256 tokenNow = _tokenIds.current(); // get the id token

        addOnMetadata(tokenNow, _name, _blockchain, _size, _type, _map); // add data to struct first so the tokenURI can process it
        _safeMint(msg.sender, tokenNow); // trying to minting

        _tokenIds.increment();
    }

}