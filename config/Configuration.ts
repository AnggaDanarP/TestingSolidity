import * as fs from 'fs';
import * as path from 'path';
import CollectionConfigInterface from "../lib/InterfaceConfig";
import * as Networks from "../lib/Network";
import * as Marketplace from "../lib/Marketplace";

const fileContents = fs.readFileSync(path.resolve('./imageNFT/example.svg'), 'utf8');

const Configuration: CollectionConfigInterface = {
    testnet: Networks.polygonTestnet,
    mainet: Networks.polygonMainnet,
    contractName: "NftParcelMetaverse",
    tokenName: "TestingMeta",
    tokenSymbol: "TMT",
    metadata: fileContents,
    //metadata: '<svg height="100" width="100"><circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" /> </svg>',
    contractAddress: "0xAEfe55E7cfA9266B4A2c2DBf52f23A721F2702A9",
    marketplaceIdentifier: "This is only demo nft for building metaverse",
    marketplaceConfig: Marketplace.openSea,
};

export default Configuration;