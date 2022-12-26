import { utils } from 'ethers';
import CollectionConfig from "./Configuration";

const ContractArgument = [
    CollectionConfig.tokenName,
    CollectionConfig.tokenSymbol,
    utils.parseEther(CollectionConfig.whitelistSale.price.toString()),
    CollectionConfig.maxSupply,
    CollectionConfig.whitelistSale.maxMintAmountPerTx,
    CollectionConfig.hiddenMetadataUri,
] as const;

export default ContractArgument;