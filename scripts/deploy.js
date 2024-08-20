async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB");

    const MyContract = await ethers.getContractFactory("MyContract");
    const contract = await MyContract.deploy();
    console.log("Contract deployed to address:", "0xd7B63981A38ACEB507354DF5b51945bacbe28414");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});