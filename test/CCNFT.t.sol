// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BUSD} from "../src/BUSD.sol";
import {CCNFT} from "../src/CCNFT.sol";

// Definición del contrato de prueba CCNFTTest que hereda de Test.
// Declaración de direcciones y dos instancias de contratos (BUSD y CCNFT).
contract CCNFTTest is Test {
    address deployer;
    address c1;
    address c2;
    address funds;
    address fees;
    BUSD busd;
    CCNFT ccnft;

// Ejecución antes de cada prueba.
// Inicializar las direcciones y desplgar las instancias de BUSD y CCNFT.
    function setUp() public {
        deployer = makeAddr("deployer");
        c1 = makeAddr("c1");
        c2 = makeAddr("c2");
        funds = makeAddr("funds");
        fees = makeAddr("fees");

        // Con prank, msg.sender del constructor es deployer: queda como owner de CCNFT.
        vm.startPrank(deployer);
        busd = new BUSD();
        ccnft = new CCNFT();
        vm.stopPrank();
    }

// Prueba de "setFundsCollector" del contrato CCNFT.
// Llamar al método y despues verificar que el valor se haya establecido correctamente.
    function testSetFundsCollector() public {
        vm.prank(deployer);
        ccnft.setFundsCollector(funds);
        assertEq(ccnft.fundsCollector(), funds);
    }

// Prueba de "setFeesCollector" del contrato CCNFT
// Verificar que el valor se haya establecido correctamente.
    function testSetFeesCollector() public {
        vm.prank(deployer);
        ccnft.setFeesCollector(fees);
        assertEq(ccnft.feesCollector(), fees);
    }

// Prueba de "setProfitToPay" del contrato CCNFT
// Verificar que el valor se haya establecido correctamente.
    function testSetProfitToPay() public {
        vm.prank(deployer);
        ccnft.setProfitToPay(500);
        assertEq(ccnft.profitToPay(), 500);
    }

// Prueba de "setCanBuy" primero estableciéndolo en true y verificando que se establezca correctamente.
// Despues establecerlo en false verificando nuevamente.
    function testSetCanBuy() public {
        vm.startPrank(deployer);
        ccnft.setCanBuy(true);
        assertTrue(ccnft.canBuy());
        ccnft.setCanBuy(false);
        assertFalse(ccnft.canBuy());
        vm.stopPrank();
    }

// Prueba de método "setCanTrade". Similar a "testSetCanBuy".
    function testSetCanTrade() public {
        vm.startPrank(deployer);
        ccnft.setCanTrade(true);
        assertTrue(ccnft.canTrade());
        ccnft.setCanTrade(false);
        assertFalse(ccnft.canTrade());
        vm.stopPrank();
    }

// Prueba de método "setCanClaim". Similar a "testSetCanBuy".
    function testSetCanClaim() public {
        vm.startPrank(deployer);
        ccnft.setCanClaim(true);
        assertTrue(ccnft.canClaim());
        ccnft.setCanClaim(false);
        assertFalse(ccnft.canClaim());
        vm.stopPrank();
    }

// Prueba de "setMaxValueToRaise" con diferentes valores.
// Verifica que se establezcan correctamente.
    function testSetMaxValueToRaise() public {
        vm.startPrank(deployer);
        ccnft.setMaxValueToRaise(1000 ether);
        assertEq(ccnft.maxValueToRaise(), 1000 ether);
        ccnft.setMaxValueToRaise(5000 ether);
        assertEq(ccnft.maxValueToRaise(), 5000 ether);
        vm.stopPrank();
    }

// Prueba de "addValidValues" añadiendo diferentes valores.
// Verificar que se hayan añadido correctamente.
    function testAddValidValues() public {
        assertFalse(ccnft.validValues(100 ether));
        assertFalse(ccnft.validValues(200 ether));

        vm.startPrank(deployer);
        ccnft.addValidValues(100 ether);
        ccnft.addValidValues(200 ether);
        vm.stopPrank();

        assertTrue(ccnft.validValues(100 ether));
        assertTrue(ccnft.validValues(200 ether));
        assertFalse(ccnft.validValues(300 ether));
    }

// Prueba de "setMaxBatchCount".
// Verifica que el valor se haya establecido correctamente.
    function testSetMaxBatchCount() public {
        vm.prank(deployer);
        ccnft.setMaxBatchCount(10);
        assertEq(ccnft.maxBatchCount(), 10);
    }

// Prueba de "setBuyFee".
// Verificar que el valor se haya establecido correctamente.
    function testSetBuyFee() public {
        vm.prank(deployer);
        ccnft.setBuyFee(250);
        assertEq(ccnft.buyFee(), 250);
    }

// Prueba de "setTradeFee".
// Verificar que el valor se haya establecido correctamente.
    function testSetTradeFee() public {
        vm.prank(deployer);
        ccnft.setTradeFee(300);
        assertEq(ccnft.tradeFee(), 300);
    }

// Prueba de que no se pueda comerciar cuando canTrade es false.
// Verificar que se lance un error esperado.
    function testCannotTradeWhenCanTradeIsFalse() public {
        // canTrade arranca en false (valor por defecto).
        vm.prank(c1);
        vm.expectRevert("Trade disabled");
        ccnft.trade(1);
    }

// Prueba que no se pueda comerciar con un token que no existe, incluso si canTrade es true.
// Verificar que se lance un error esperado.
    function testCannotTradeWhenTokenDoesNotExist() public {
        vm.prank(deployer);
        ccnft.setCanTrade(true);

        vm.prank(c1);
        vm.expectRevert("Token does not exist");
        ccnft.trade(999);
    }
}
