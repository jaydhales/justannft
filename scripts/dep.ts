import { ethers } from "hardhat";

async function main() {
  const Consumer = await ethers.deployContract("VRFv2Consumer", [14220]);

  await Consumer.waitForDeployment();

  console.log(Consumer.target);
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
