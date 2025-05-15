// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./Scientific_calculator.sol";
// address casting , Low-level call
contract Contract {
    address public owner;
    address public Scientific_calculator_address;

    constructor(){
       owner = msg.sender;
    }
    function import_address(address _address)public {
         Scientific_calculator_address = _address;
    } 
    
    function add(uint a, uint b) public pure returns(uint){
        return a+b;
    }
    function mul(uint a, uint b) public pure returns(uint){
        return a*b;
    }
    function sub(int a, int b) public pure returns(int){
        return a-b;
    }
    function div(uint a, uint b) public pure returns(uint){
        require(b!= 0, "Cannot divide by zero"); 
        return a/b;
    }
    //this is a low-level call to extract other contracts function
    function squareRoot(uint256 number)public  returns(uint256){
        (bool success , bytes memory data) = Scientific_calculator_address.call(abi.encodeWithSignature("squareRoot(uint256)", 3));
        require(success,"External call failed");
        uint result =   abi.decode(data,(uint256));
        return result;
    }
     
  
function calculatePower(uint256 base, uint256 exponent) public view returns(uint256) {

    // Fix 1: Used correct contract type 'ScientificCalculator'
    // Fix 2: Declared instance variable as 'scientificCalc'
    ScientificCalculator scientificCalc = ScientificCalculator(Scientific_calculator_address);

    // External call - now uses the correctly declared instance 'scientificCalc'
    uint256 result = scientificCalc.power(base, exponent);

    return result;
}
}
