// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";

contract DeployAndUpgradeUsingScriptTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public proxyAddress;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxyAddress = deployer.run(); // right now, points to BoxV1
    }

    function testProxyStartsAsBoxV1() public {
        uint256 expectedVersion = 1;
        assertEq(expectedVersion, BoxV1(proxyAddress).version());

        uint256 expectedValue = 7;
        vm.expectRevert();
        BoxV2(proxyAddress).setNumber(expectedValue);
    }

    function testUpgradeToBoxV2Works() public {
        console.log("Owner: ", BoxV1(proxyAddress).owner());
        console.log("Caller: ", msg.sender);

        // Deploy new Implementation
        BoxV2 box2 = new BoxV2();

        vm.prank(BoxV1(proxyAddress).owner());
        // Since prank and broadcasting aren't compatible, first transfer ownership before running script funciton
        BoxV1(proxyAddress).transferOwnership(msg.sender);

        upgrader.upgradeBox(proxyAddress, address(box2));

        uint256 expectedVersion = 2;
        assertEq(expectedVersion, BoxV2(proxyAddress).version());

        BoxV2(proxyAddress).setNumber(7);
        assertEq(7, BoxV2(proxyAddress).getNumber());
    }
}
