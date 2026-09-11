// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/Proxy.sol";

contract SmallProxy is Proxy {
    // This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // Places an Implemetation to this special storage slot _IMPLEMENTATION_SLOT at index 0
    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    // Reads and return the current Implementation at first index of _IMPLEMENTATION_SLOT
    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    // Helper function to get function selector + arguement used to call Implementation function "setValue()"
    function getDataToTransact(uint256 numberToUpdate) public pure returns (bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate);
    }

    // Reads the storage slot 0 of this current contract SmallProxy
    function readStorage() public view returns (uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }

    receive() external payable {}
}

contract ImplementationA {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}

contract ImplementationB {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue + 2;
    }
}

// function setImplementation(){}
// Transparent Proxy -> Ok, only admins can call functions on the proxy
// anyone else ALWAYS gets sent to the fallback contract.

// UUPS -> Where all upgrade logic is in the implementation contract, and
// you can't have 2 functions with the same function selector.
