import NetworkConfigInterface from "./InterfaceNetwork";
import MarketplaceConfigInterface from "./InterfaceMarketplace";

interface SaleConfig {
    price: number;
    maxMintAmountPerTx: number;
  };

export default interface InterfaceConfig {
    testnet: NetworkConfigInterface;
    mainet: NetworkConfigInterface;
    contractName: string;
    tokenName: string;
    tokenSymbol: string;
    hiddenMetadataUri: string;
    maxSupply: number;
    whitelistSale: SaleConfig;
    publicSale: SaleConfig;
    contractAddress: string|null;
    marketplaceIdentifier: string;
    marketplaceConfig: MarketplaceConfigInterface;
};