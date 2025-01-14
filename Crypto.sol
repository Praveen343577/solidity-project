// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    function deposit() external payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        // Deduct balance AFTER external call (reentrancy issue)
        balances[msg.sender] -= amount;
    }
    function executeDelegateCall(address target, bytes memory data) external {
        require(msg.sender == owner, "Only owner can execute"); 
        (bool success, ) = target.delegatecall(data); // Delegatecall injection vulnerability
        require(success, "Delegatecall failed");
    }
    function transferAllFunds(address payable to) external {
        to.transfer(address(this).balance);
    }

    fallback() external payable {}
    receive() external payable {}
}









































































