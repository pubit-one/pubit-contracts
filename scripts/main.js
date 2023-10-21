const hre = require("hardhat");
const { ethers } = require("hardhat");

const deploy_access_restriction = require("./deploy/deploy_access_restriction");
const deploy_license_registry = require("./deploy/deploy_license_registry");

async function main() {
  // deploy contracts
    const arAddress = await deploy_access_restriction();
    const LicenseRegistry = await deploy_license_registry(arAddress);
  
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
