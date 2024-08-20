const MyContract = artifacts.require("MyContract");

contract("MyContract", (accounts) => {
    it("should deploy the contract", async () => {
        const instance = await MyContract.deployed();
        assert(instance.address !== '');
    });

    it("should perform an action", async () => {
        const instance = await MyContract.deployed();
        const result = await instance.someFunction();
        assert.equal(result.toString(), 'expectedValue');
    });
});