// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {BUSD} from "../src/BUSD.sol";
import {CCNFT} from "../src/CCNFT.sol";

// Despliega BUSD y luego CCNFT. La configuración posterior (setters) se hace a mano en Etherscan.
contract DeployScript is Script {
    function run() external {
        // La clave privada se lee del entorno (nunca va escrita en el código). Debe llevar prefijo 0x.
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        BUSD busd = new BUSD();
        CCNFT ccnft = new CCNFT();

        vm.stopBroadcast();

        console.log("BUSD desplegado en:", address(busd));
        console.log("CCNFT desplegado en:", address(ccnft));
    }
}
