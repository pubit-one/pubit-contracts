const hre = require("hardhat");
const { ethers } = require("hardhat");

async function deploy_license_registry(arAddress) {

  console.log("Deploying the LicenseRegistry contract...");

  const licenseRegistryInstance = await hre.ethers.deployContract(
    "LicenseRegistry",
    [arAddress]
  );

  await licenseRegistryInstance.waitForDeployment();

  // console.log(arInstance.BaseContract.target);

  // Deploy AccessRestriction
  // const accessRestriction = await ethers.getContractFactory(
  //   "AccessRestriction"
  // );
  // // const arInstance = await accessRestriction.deploy(deployer.address);
  // console.log(arInstance.address);
  // await arInstance.deployed();

  console.log(
    "LicenseRegistry Contract deployed to:",
    licenseRegistryInstance.target
  );
  console.log("---------------------------------------------------------");
  return licenseRegistryInstance.target;
}

module.exports = deploy_license_registry;
