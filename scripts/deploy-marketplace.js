require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");

async function main() {
    const deployers = await ethers.getSigners();
    const deployer = deployers[0] //B
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Contract = await ethers.getContractFactory("Marketplace");
    const contract = await Contract.connect(deployer)
    .deploy(
        "0x575c24171dA5c184f84d8265ac244c92Bf2560B2",
        "0x5E8ADe46664E96F1036d9D8016da68B170E84A96"
    );
  
    console.log("Contract address:", contract.address);
}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});