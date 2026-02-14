async function main() {
  const InteractionHub = await ethers.getContractFactory("InteractionHub");

  const hub = await InteractionHub.deploy(
    "0x85363186B53dEE5956b77dECf5618B540b8c0E7c" // TrustRegistry address
  );

  await hub.waitForDeployment();

  console.log("InteractionHub deployed to:", await hub.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
