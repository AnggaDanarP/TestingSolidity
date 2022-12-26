// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RealityChain is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdSmall2d;
    Counters.Counter private _tokenIdMedium2d;
    Counters.Counter private _tokenIdLarge2d;

    Counters.Counter private _tokenIdSmall3d;
    Counters.Counter private _tokenIdMedium3d;
    Counters.Counter private _tokenIdLarge3d;

    struct Token {
        address owner;
        uint256 assetId;
        string uri;
        bool isClaimed;
    }
    mapping(uint256 => Token) internal _tokenSeries;

    string public parcelURI;
    address public signerAddress;

    struct LandSpec {
        uint256 price;
        uint256 maxSupply;
        uint256 startTokenId;
    }

    enum TypeLand {
        d2, //2d
        d3 //3d
    }

    enum Size {
        Small,
        Medium,
        Large
    }

    mapping(TypeLand => mapping(Size => LandSpec)) private world;

    event MintParcel(uint256 indexed tokenId, uint256 assetId);
    event ClaimLand(uint256 assetId, string metadata);

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        string memory uriParcel
    ) ERC721(tokenName, tokenSymbol) {
        setSignerAddress(msg.sender);
        setParcelURI(uriParcel);

        // set up  the world
        world[TypeLand.d2][Size.Small] = LandSpec(3 ether, 100, 1);
        world[TypeLand.d3][Size.Small] = LandSpec(3 ether, 100, 101);
        world[TypeLand.d2][Size.Medium] = LandSpec(5 ether, 500, 201);
        world[TypeLand.d3][Size.Medium] = LandSpec(5 ether, 500, 701);
        world[TypeLand.d2][Size.Large] = LandSpec(7 ether, 1000, 1201);
        world[TypeLand.d3][Size.Large] = LandSpec(7 ether, 1000, 2201);
    }

    /**
     * ==============================================================================
     *                                  MODIFIER
     * ==============================================================================
     */
    modifier onlyEOA(address minter) {
        require(Address.isContract(minter), "no contracts please");
        _;
    }

    modifier mintCompliance(TypeLand typeLand, Size size) {
        require(
            _currentToken(typeLand, size) + 1 <=
                _getSpecLand(typeLand, size).maxSupply,
            "Supply exceeded"
        );
        require(
            msg.value >= _getSpecLand(typeLand, size).price,
            "Not enough ether"
        );
        _;
    }

    /**
     * ==============================================================================
     *                                   SET FUNCTION
     * ==============================================================================
     */

    function setSignerAddress(address signer) public onlyOwner {
        signerAddress = signer;
    }

    function setParcelURI(string memory uri) public onlyOwner {
        parcelURI = uri;
    }

    function setPrice(
        TypeLand typeLand,
        Size size,
        uint256 price
    ) public view onlyOwner {
        _getSpecLand(typeLand, size).price = price;
    }

    /**
     * ==============================================================================
     *                                  GET FUNCTION
     * ==============================================================================
     */
    function getTokenOwner(uint256 tokenId) public view returns (address) {
        return _tokenSeries[tokenId].owner;
    }

    function getAssetId(uint256 tokenId) public view returns (uint256) {
        return _tokenSeries[tokenId].assetId;
    }

    function _getSpecLand(TypeLand typeLand, Size size)
        internal
        view
        returns (LandSpec memory)
    {
        return world[typeLand][size];
    }

    function _getTokenIdMinting(TypeLand typeLand, Size size)
        private
        view
        returns (uint256)
    {
        unchecked {
            return
                _currentToken(typeLand, size) +
                _getSpecLand(typeLand, size).startTokenId;
        }
    }

    /**
     * ==============================================================================
     *                                   WITHDRAW
     * ==============================================================================
     */
    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Failed: no funds to withdraw");
        Address.sendValue(payable(msg.sender), address(this).balance);
    }

    /**
     * ==============================================================================
     *                                    VERIFY
     * ==============================================================================
     */
    function verifyHash(
        bytes32 hash,
        bytes32 signatureR,
        bytes32 signatureVS
    ) public pure returns (address signer) {
        bytes32 messageDigest = ECDSA.toEthSignedMessageHash(hash);
        return ECDSA.recover(messageDigest, signatureR, signatureVS);
    }

    /**
     * ==============================================================================
     *                                    MINTING
     * ==============================================================================
     */
    function mintParcelOneOwner(
        uint256 assetId,
        TypeLand typeLand,
        Size size
    ) internal onlyEOA(_msgSender()) mintCompliance(typeLand, size) {
        uint256 tokenId = _getTokenIdMinting(typeLand, size);
        _incrementToken(typeLand, size);
        _mint(_msgSender(), tokenId);
        _setTokenURI(tokenId, assetId, "");
        emit MintParcel(tokenId, assetId);
    }

    // 2D World Minting
    function mintSmall2d(uint256 assetId) public {
        mintParcelOneOwner(assetId, TypeLand.d2, Size.Small);
    }

    function mintMedium2d(uint256 assetId) public {
        mintParcelOneOwner(assetId, TypeLand.d2, Size.Medium);
    }

    function mintLarge2d(uint256 assetId) public {
        mintParcelOneOwner(assetId, TypeLand.d2, Size.Large);
    }

    // 3D World Minting
    function mintSmall3d(uint256 assetId) public {
        mintParcelOneOwner(assetId, TypeLand.d3, Size.Small);
    }

    function mintMedium3d(uint256 assetId) public {
        mintParcelOneOwner(assetId, TypeLand.d3, Size.Medium);
    }

    function mintLarge3d(uint256 assetId) public {
        mintParcelOneOwner(assetId, TypeLand.d3, Size.Large);
    }

    /**
     * ==============================================================================
     *                                 UPDATE METADATA
     * ==============================================================================
     */
    function claimLand(uint256 tokenId, string memory uri) public onlyOwner {
        require(
            _tokenSeries[tokenId].isClaimed == false,
            "Token already claimed"
        );
        _tokenSeries[tokenId].isClaimed = true;
        _tokenSeries[tokenId].uri = uri;
        emit ClaimLand(_tokenSeries[tokenId].assetId, uri);
    }

    /**
     * ==============================================================================
     *                                   METADATA
     * ==============================================================================
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "URI query for nonexistent token");

        string memory currentBaseURI = _tokenSeries[tokenId].uri;
        uint256 assetId = _tokenSeries[tokenId].assetId;
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        assetId.toString(),
                        ".json"
                    )
                )
                : parcelURI;
    }

    function _setTokenURI(
        uint256 _tokenId,
        uint256 _assetId,
        string memory _uri
    ) internal {
        require(_exists(_tokenId), "Nonexistent token");
        _tokenSeries[_tokenId].assetId = _assetId;
        _tokenSeries[_tokenId].uri = _uri;
        _tokenSeries[_tokenId].isClaimed = false;
    }

    /**
     * ==============================================================================
     *                                TOKEN FUNCTION
     * ==============================================================================
     */
    function _currentToken2d(Size size)
        private
        view
        returns (Counters.Counter storage)
    {
        if (size == Size.Small) {
            return _tokenIdSmall2d;
        }
        if (size == Size.Medium) {
            return _tokenIdMedium2d;
        }
        if (size == Size.Large) {
            return _tokenIdLarge2d;
        }
        revert("invalid size");
    }

    function _currentToken3d(Size size)
        private
        view
        returns (Counters.Counter storage)
    {
        if (size == Size.Small) {
            return _tokenIdSmall3d;
        }
        if (size == Size.Medium) {
            return _tokenIdMedium3d;
        }
        if (size == Size.Large) {
            return _tokenIdLarge3d;
        }
        revert("invalid size");
    }

    function _counterLand(TypeLand typeLand, Size size)
        private
        view
        returns (Counters.Counter storage)
    {
        if (typeLand == TypeLand.d2) {
            return _currentToken2d(size);
        }
        if (typeLand == TypeLand.d3) {
            return _currentToken3d(size);
        }
        revert("invalid type map");
    }

    function _currentToken(TypeLand typeLand, Size size)
        internal
        view
        returns (uint256 _currentTokenId)
    {
        _currentTokenId = Counters.current(_counterLand(typeLand, size));
        return _currentTokenId;
    }

    function _incrementToken(TypeLand typeLand, Size size) internal {
        unchecked {
            Counters.increment(_counterLand(typeLand, size));
        }
    }
}
