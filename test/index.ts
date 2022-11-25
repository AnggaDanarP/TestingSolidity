import { ethers } from "hardhat";
import { utils } from "ethers";
import Configuration from "../config/Configuration";
import ContractArguments from "../config/ContractArgument";
import { NftContractType } from "../lib/NftContractProvider";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

const gassfee = {gasPrice: utils.parseUnits('100', 'gwei'), gasLimit: 1000000};

describe(Configuration.contractName, function () {
  let owner!: SignerWithAddress;
  let user!: SignerWithAddress;
  let contract!: NftContractType;

  before(async function() {
    [owner, user] = await ethers.getSigners();
  });

  it("Deploy contract", async function () {
    const Contract = await ethers.getContractFactory(Configuration.contractName, owner);
    contract = await Contract.deploy(...ContractArguments) as NftContractType;

    await contract.deployed(), gassfee;
  });

  it("Minting NFT", async function () {
    await contract.connect(user).claimNftParcel("Large", "3d", "My Riad Town");
  });

  it("Print URI", async function () {
    const Uri = await contract.connect(owner).tokenURI(1);
    console.log(Uri);
  });
});
