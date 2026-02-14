async function main() {
  const Identity = await ethers.getContractFactory("Identity");

  const owner = "0x92E23fd9d38ac79B09f9c0CC93aAA3323A807BD7";

  const guardians = [
    "0x85E58d277d6Ef7EC36F740dE387eb1e6DE7783a1",
    "0xAnotherGuardianAddress"
  ];

  const threshold = 2;

  const identity = await Identity.deploy(owner, guardians, threshold);

  await identity.waitForDeployment();

  console.log("Identity deployed to:", await identity.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
