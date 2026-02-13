const hre = require("hardhat");
const { ethers } = hre;

async function main() {
  const contractAddress = "0xEf5bCeB0F946f360aBf0dd42ff3736f64Ece73e3";

  const Contract = await ethers.getContractFactory("NeuralHashSSI");
  const contract = await Contract.attach(contractAddress);

  const userAddress = "0x92E23fd9d38ac79B09f9c0CC93aAA3323A807BD7";

  const credential = {
    type: "Degree",
    name: "Aditi Saxena",
    university: "ABC University",
    year: 2026
  };

  const hash = ethers.keccak256(
    ethers.toUtf8Bytes(JSON.stringify(credential))
  );

  const tx = await contract.issueCredential(
    userAddress,
    hash,
    "fakeCID123"
  );

  await tx.wait();

  console.log("Credential issued successfully!");
}

main().catch(console.error);
