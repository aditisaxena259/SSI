const hre = require("hardhat");
const { ethers } = hre;

async function main() {
  const contractAddress = "0xEf5bCeB0F946f360aBf0dd42ff3736f64Ece73e3";

  const Contract = await ethers.getContractFactory("NeuralHashSSI");
  const contract = await Contract.attach(contractAddress);

  const userAddress = "0x92E23fd9d38ac79B09f9c0CC93aAA3323A807BD7";

  const creds = await contract.getUserCredentials(userAddress);

  console.log("User Credentials:", creds);
}

main().catch(console.error);
