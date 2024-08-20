// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FlashUSDT is ERC20, Ownable {
    uint256 public reffee = 5;
    uint256 public totalfeecollect;
    mapping(address => uint256) public lastclaim;
    mapping(address => uint256) public reflections;
    uint256 public flashDuration = 365 days;

    event ReflectionClaimed(address indexed holder, uint256 amount);

    constructor(uint256 initialSupply) ERC20("Flash USDT", "FUSDT") Ownable(0xd9E588A3f7567dBC976adb8fC9881ce1704ea839) {
        _mint(0xd9E588A3f7567dBC976adb8fC9881ce1704ea839, initialSupply * (10 ** decimals()));
    }

    function transferWithReflection(address recipient, uint256 amount) public {
        address sender = _msgSender();

        require(block.timestamp - lastclaim[sender] <= flashDuration, "Flash duration expired");
        uint256 fee = (amount * reffee) / 100;
        uint256 amountAfterFee = amount - fee;

        // Transfer the fee to the contract
        _transfer(sender, address(this), fee);
        // Transfer the rest to the recipient
        _transfer(sender, recipient, amountAfterFee);
        totalfeecollect += fee;

        reflections[recipient] += fee;
        reflections[sender] += fee;
        lastclaim[sender] = block.timestamp;
    }

    function claimReflection() public {
        uint256 owed = reflections[msg.sender];
        require(owed > 0, "No reflections to claim");
        reflections[msg.sender] = 0;
        _mint(msg.sender, owed);
        emit ReflectionClaimed(msg.sender, owed);
    }

    function setreffee(uint256 newFee) external onlyOwner {
        require(newFee <= 10, "Fee too high");
        reffee = newFee;
    }

    function setFlashDuration(uint256 newDuration) external onlyOwner {
        flashDuration = newDuration;
    }

    function withdrawFees() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}
}
