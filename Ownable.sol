// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Ownable{
    address public owner;
    event ownerChanged(address _address , string message);
    constructor(){
        owner =msg.sender;
    }
    modifier onlyOwner(){
        require(owner == msg.sender,"Not the real owner");
        _;
    }

    function ownerAddress() public view returns(address){
        return owner;
    }
    function changeOwner(address _address) public onlyOwner {
        require(_address != address(0), "No address assigning to zero address");
        owner = _address;
        emit ownerChanged(_address, "owner changed to");
    }
}