// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.12 <=0.9.0;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Whatever is ERC721URIStorage {
    uint256 public tokenCounter;
    event CreatedSVGNFT(uint256 indexed tokenId, string tokenURI);

    string public imageSVG;

    constructor(
        string memory _name, 
        string memory _symbol,
        string memory _imageSVG) 
    ERC721(_name, _symbol) {
        tokenCounter = 0;
        setImage(_imageSVG);
    }

    function setImage(string memory _imageSVG) public {
        imageSVG = _imageSVG;
    }

    function create() public {
        _safeMint(msg.sender, tokenCounter);
        string memory imageURI = svgToImageURI(imageSVG);
        _setTokenURI(tokenCounter, formatTokenURI(imageURI));
        tokenCounter = tokenCounter + 1;
        emit CreatedSVGNFT(tokenCounter, imageSVG);
    }

    function svgToImageURI(string memory _svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(_svg))));
        return string.concat(baseURL, svgBase64Encoded);
    }

    function formatTokenURI(string memory imageURI) public pure returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "Testing Metaverse", // You can add whatever name here
                                '", "description":"An NFT based on SVG!", "attributes":"", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
    }

}