//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @dev NOTE: Why contracts that are meant to be used via Proxy don't use constructors
 * Remember storage is stored in Proxy NOT Implementation.
 * If Implementation has constructor(where it sets number = 1), number in Proxy will still be 0.
 *
 * Instead: Deploy Implementation and THEN call some "initializer" function
 * This function acts as the constructor but it's gonna be called on the Proxy
 */
contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        // This is to prevent any initialization that will probably change the contract state,
        // Thereby conflicting the storage state of the Proxy and Implementation contract from ever happening.
        // It's Same thing as not having any constructor but this more robust
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        // Whatever initialization we need should be put here so Proxy contract can immediately call this
        // And initialize it's own state or storage instead of the Implementation's

        __Ownable_init(initialOwner); // sets owner to: owner = msg.sender
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
