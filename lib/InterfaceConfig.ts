import NetworkConfigInterface from "./InterfaceNetwork";
import MarketplaceConfigInterface from "./InterfaceMarketplace";

export default interface InterfaceConfig {
    testnet: NetworkConfigInterface;
    mainet: NetworkConfigInterface;
    contractName: string;
    tokenName: string;
    tokenSymbol: string;
    metadata: string;
    contractAddress: string|null;
    marketplaceIdentifier: string;
    marketplaceConfig: MarketplaceConfigInterface;
};