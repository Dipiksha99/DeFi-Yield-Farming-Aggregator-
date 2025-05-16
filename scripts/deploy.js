const hre = require("hardhat");

async function main() {
  console.log("Deploying Project contract...");

  const Project = await hre.ethers.getContractFactory("Project");
  const project = await Project.deploy();

  await project.waitForDeployment();

  const address = await project.getAddress();
  console.log(`Project deployed to: ${address}`);
  
  console.log("Deployment complete!");
  
  // For verification later
  console.log("Contract deployment details for verification:");
  console.log(`npx hardhat verify --network coreTestnet2 ${address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
