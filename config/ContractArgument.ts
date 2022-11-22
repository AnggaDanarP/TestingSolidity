import CollectionConfig from "./Configuration";

const ContractArgument = [
    CollectionConfig.tokenName,
    CollectionConfig.tokenSymbol,
    CollectionConfig.metadata
] as const;

export default ContractArgument;