import { ethers } from "hardhat";

async function main() {
  const Consumer = await ethers.getContractAt(
    "VRFv2Consumer",
    "0xc18327Ca7Dfff516f55D645dd3Eb5b6C628E410f"
  );

  // const  req = await Consumer.requestRandomWords();
  // await req.wait()

  const getter = await Consumer.requestIds(0);

  const stats = await Consumer.getRequestStatus(getter);

  console.log({ stats, getter });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
