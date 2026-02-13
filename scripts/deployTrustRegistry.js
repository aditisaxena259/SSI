const hre = require("hardhat");

async function main() {
  const TrustRegistry = await hre.ethers.getContractFactory("NeuralHashTrustRegistry");
  const trustRegistry = await TrustRegistry.deploy();

  await trustRegistry.waitForDeployment();

  console.log("TrustRegistry deployed to:", await trustRegistry.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
