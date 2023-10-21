const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_access_restriction() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying the Access Restriction contract...");

  const arInstance = await hre.ethers.deployContract("AccessRestriction", [
    deployer.address,
  ]);

  await arInstance.waitForDeployment();

  // console.log(arInstance.BaseContract.target);

  // Deploy AccessRestriction
  // const accessRestriction = await ethers.getContractFactory(
  //   "AccessRestriction"
  // );
  // // const arInstance = await accessRestriction.deploy(deployer.address);
  // console.log(arInstance.address);
  // await arInstance.deployed();

  console.log(
    "Access Restriction Contract deployed to:",
    arInstance.target
  );
  console.log(
    "---------------------------------------------------------",
  );
  return arInstance.target;
}

module.exports = deploy_access_restriction;
