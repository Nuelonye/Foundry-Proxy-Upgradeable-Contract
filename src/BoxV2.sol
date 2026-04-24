//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        // We cant use constructors with Proxies WHY?
        // Because Implementation will update state immediately contract is deloyed and Proxy will NOT
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        // The initialize function instead serves as conctructors for Proxies, They can ony be called once
        // Function called here are pre-pended with double underscore __ to signify initialization functions

        __Ownable_init(initialOwner); // sets owner to: owner = msg.sender
    }

    function setNumber(uint256 _newNumber) public {
        number = _newNumber;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 2;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
