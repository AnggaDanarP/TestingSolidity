import CollectionConfigInterface from "../lib/InterfaceConfig";
import * as Networks from "../lib/Network";
import * as Marketplace from "../lib/Marketplace";
import whitelistAddresses from './whitelist.json';

const Configuration: CollectionConfigInterface = {
    testnet: Networks.polygonTestnet,
    mainet: Networks.polygonMainnet,
    contractName: "RealityChain",
    tokenName: "TestingMeta",
    tokenSymbol: "TMT",
    hiddenMetadataUri: 'ipfs://__CID__/hidden.json',
    maxSupply: 10000,
    whitelistSale: {
        price: 0.05,
        maxMintAmountPerTx: 1,
      },
      publicSale: {
        price: 0.09,
        maxMintAmountPerTx: 5,
      },
    contractAddress: "0xBA0Cc0d0Ed76d0f63E6207a9156600BEa415Ab73",
    marketplaceIdentifier: "This is only demo nft for building metaverse",
    marketplaceConfig: Marketplace.openSea,
};

export default Configuration;