const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const Contract = await hre.ethers.getContractFactory("NeuralHashSSI");

  // Deploy the contract
  const contract = await Contract.deploy();

  // Wait for deployment to finish
  await contract.waitForDeployment();

  console.log("Contract deployed to:", await contract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
