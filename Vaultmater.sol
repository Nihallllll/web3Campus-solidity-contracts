// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./Ownable.sol";


contract VaultMaster is Ownable {
    event amountDeposited(uint _amount , string message);
    event withSuccess(uint _amount , address _address);
    function getBalance()public view returns(uint){
      return address(this).balance;
    }

    function deposite() public payable{
      require(msg.value != 0, "Please enter some amount");
      emit amountDeposited(msg.value, "Amount deposited");
    }
    function withDraw(address _to , uint amount) public onlyOwner{
      require(amount > 0);
      (bool success , ) = payable(_to).call{value: amount}("");
      require(success ,"Transfer failed" );
      emit withSuccess( amount, _to);      
    }
}
