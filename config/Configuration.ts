import * as fs from 'fs';
import * as path from 'path';
import CollectionConfigInterface from "../lib/InterfaceConfig";
import * as Networks from "../lib/Network";
import * as Marketplace from "../lib/Marketplace";

const fileContents = fs.readFileSync(path.resolve(__dirname, './imageNFT/example.svg'), 'utf8');

const Configuration: CollectionConfigInterface = {
    testnet: Networks.polygonTestnet,
    mainet: Networks.polygonMainnet,
    contractName: "Whatever",
    tokenName: "TestingMeta",
    tokenSymbol: "TMT",
    metadata: fileContents,
    contractAddress: null,
    marketplaceIdentifier: "This is only demo nft for building metaverse",
    marketplaceConfig: Marketplace.openSea,
};

export default Configuration;