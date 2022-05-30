require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");

async function main() {
    const deployers = await ethers.getSigners();
    const deployer = deployers[0] //B
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Contract = await ethers.getContractFactory("FunToken");
    const contract = await Contract.connect(deployer)
    .deploy(
        "0x8FE2ff52648f6e14f73993d5D6696521d2BdBc05"
    );
  
    console.log("Contract address:", contract.address);
}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});