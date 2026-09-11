// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SmallProxy, ImplementationA, ImplementationB} from "../src/sublesson/SmallProxy.sol";

contract SmallProxyTest is Test {
    SmallProxy proxy;
    ImplementationA a;
    ImplementationB b;

    function setUp() public {
        proxy = new SmallProxy();
        a = new ImplementationA();
        b = new ImplementationB();

        console.log("valueAtStorageSlotZeroBeforeSettingImplementation: ", proxy.readStorage());

        proxy.setImplementation(address(a));
    }

    function testProxyUpdatesValueThroughImplementationA() public {
        (bool success,) = address(proxy).call(abi.encodeWithSelector(a.setValue.selector, 15));
        assertTrue(success);
        // assertEq(a.value(), 15); // When using proxies, the storage state of the Implementation contract is never changed
        assertEq(proxy.readStorage(), 15); // Rather only the storage of the proxy itself is changed

        console.log("valueAtStorageSlotZeroAfterSettingImplementationAndStoringValue: ", proxy.readStorage());
    }

    function testUpgradeProxyAndSetValueThroughImplementationB() public {
        proxy.setImplementation(address(b));

        uint256 valueToStore = 15;

        (bool success,) = address(proxy).call(proxy.getDataToTransact(valueToStore));
        assertTrue(success);
        assertEq(proxy.readStorage(), 17); // Since ImplementationB add 2

        console.log("valueAtStorageSlotZeroAfterUpdradingToImplementationBAndStoringValue: ", proxy.readStorage());
    }
}
