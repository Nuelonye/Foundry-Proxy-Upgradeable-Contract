// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradeTest is Test {
    BoxV1 public boxV1;
    BoxV2 public boxV2;
    address public proxyAddress;

    function setUp() public {
        boxV1 = new BoxV1();
        bytes memory data = abi.encodeWithSelector(BoxV1.initialize.selector, msg.sender); // msg.sender is DeployAndUpgradeTest = owner
        ERC1967Proxy proxy = new ERC1967Proxy(address(boxV1), data);
        proxyAddress = address(proxy);
    }

    function testProxyStartsAtBoxV1() public {
        uint256 expectedVersion = 1;
        assertEq(expectedVersion, BoxV1(proxyAddress).version());

        vm.expectRevert();
        BoxV2(proxyAddress).setNumber(7); // Trying to call V2 without first upgrading should revert
    }

    function testUpgradeToBoxV2Works() public {
        // Deploy new version
        boxV2 = new BoxV2();

        // Call for upgrade from old version
        console.log("Owner: ", BoxV1(proxyAddress).owner());
        vm.prank(BoxV1(proxyAddress).owner());
        BoxV1(proxyAddress).upgradeToAndCall(address(boxV2), "");

        // Assert the version
        uint256 expectedVersion = 2;
        assertEq(expectedVersion, BoxV2(proxyAddress).version());

        // Assert New function
        uint256 expectedNumber = 7;
        BoxV2(proxyAddress).setNumber(expectedNumber);
        assertEq(expectedNumber, BoxV2(proxyAddress).getNumber());
    }
}
