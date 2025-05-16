// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract MyToken{
    address public owner;
    string public name = "Faulty";
    string public symbol = "F";
    uint public decimal = 18;
    uint public totalSupply;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;
    constructor(uint _supply){
        totalSupply = _supply *(10 ** decimal);
    }
    modifier onlyOwner(){
       require(owner == msg.sender);
       _;
    }

    function transfer(address _from , address _to , uint amount) public onlyOwner{
       require(amount > 0);
       require(_to != address(0));
       balances[_from] -= amount;
       balances[_to] += amount;
       
    }
    function _transfer(address _to,uint amount)public virtual returns(bool){
      require(balances[msg.sender] >= amount);
      transfer(msg.sender, _to, amount);
      return true;
    }

    function  transferFrom(address _from,address _to,uint amount)public {
       require(allowances[_from][msg.sender] >= amount , "Not allowed this much");
       require(_to != address(0));
       allowances[_from][msg.sender]-=amount;
       transfer(_from, _to, amount);
    }

    function approve(address _to,uint amount)public onlyOwner{
        require(_to != address(0));
        allowances[msg.sender][_to] += amount;
    }
}