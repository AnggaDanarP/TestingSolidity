// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.12 <=0.9.0;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Test1 is ERC721URIStorage {
    uint256 public tokenCounter;
    event CreatedSVGNFT(uint256 indexed tokenId, string tokenURI);

    string public imageSVG;

    struct Attr {
        string nameWorld;
        string size;
        string _type;
        string map;
    }

    mapping(uint256 => Attr) public attribute;

    constructor(
        string memory _name, 
        string memory _symbol,
        string memory _imageSVG) 
    ERC721(_name, _symbol) {
        tokenCounter = 0;
        setImage(_imageSVG);
    }

    function create(
        string memory _nameWorld,
        string memory _size,
        string memory _type,
        string memory _map
    ) public {
            // trying to mint
            _safeMint(msg.sender, tokenCounter);

            // set firt mapping to store the attribute value from the user input
            attribute[tokenCounter] = Attr(_nameWorld, _size, _type, _map);

            // set up all the metadata and alse got the attribute
            string memory imageURI = svgToImageURI(imageSVG);
            _setTokenURI(tokenCounter, formatTokenURI(imageURI, tokenCounter));

            tokenCounter = tokenCounter + 1;
            
            emit CreatedSVGNFT(tokenCounter, imageSVG);
    }

    function setImage(string memory _imageSVG) public {
        imageSVG = _imageSVG;
    }

    function svgToImageURI(string memory _svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(_svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function getmetadataAttribute(uint256 _tokenId) public view returns (string memory) {
        return string(abi.encodePacked(
            string(abi.encodePacked('{"trait_type":"Name_World","value":"', attribute[_tokenId].nameWorld, '"},')), 
            string(abi.encodePacked('{"trait_type":"Size_World","value":"', attribute[_tokenId].size, '"},')), 
            string(abi.encodePacked('{"trait_type":"Type_Map","value":"', attribute[_tokenId]._type, '"},')), 
            string(abi.encodePacked('{"trait_type":"Name_Map","value":"', attribute[_tokenId].map, '"}'))
        ));
    }

    function formatTokenURI(string memory _imageURI, uint256 _tokenId) public view returns (string memory) {
        string memory _attribute = getmetadataAttribute(_tokenId);
        return string(
                abi.encodePacked( 
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "Testing Metaverse", // You can add whatever name here
                                '", "description":"An NFT based on SVG!",', // You can add whatever name here
                                ' "attributes":"[', _attribute,']", "image":"',_imageURI,'"}'
                            )
                        )
                    )
                )
        );
    }
}