// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import "./MyToken.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract SellTokens is MyToken{
      uint public tokenPrice;
      uint public saleStartTime;
      uint public saleEndTime;
      uint public minPurchase;
      uint public maxPurchase;
      uint public totalRaised;
      address public Coinowner;
      bool  private  initialSupplyDone;
      bool public isFinalized = false;

   constructor(
      uint _initialSupply,
      uint _tokenPrice,
      uint _saleDuration,
      uint _minPurchace,
      uint _maxPurchace,
      address _projectOwner
   )MyToken(_initialSupply){
      tokenPrice=_tokenPrice;
      saleStartTime=block.timestamp;
      saleEndTime = saleEndTime + _saleDuration;
      minPurchase=_minPurchace;
      maxPurchase=_maxPurchace;
      Coinowner = _projectOwner;

      transferFrom(msg.sender, address(this), _initialSupply);
      initialSupplyDone =true;
   }

   function isSaleActive()public view returns(bool){
      return (block.timestamp >= saleStartTime && block.timestamp <= saleEndTime);
   }

   function buyTokens() public payable{
      require(msg.value >= minPurchase,"Enter amount greater that this ");
      require(msg.value >= maxPurchase,"Enter amount less that this ");
      require(isSaleActive(),"Sale has ended");
      uint amount = (msg.value * 10**uint256(decimal))/tokenPrice;
      totalRaised += msg.value;
      transfer(address(this), msg.sender,amount);
   }
   
 // the transfer function here is modified to prevent buyers from transferring their pre-ordered tokens
 // until the project owner explicitly finalizes the sale.

   function transfer(address _to , uint _value) public  returns(bool){
      if(!isFinalized && msg.sender != address(this) && initialSupplyDone){
         require(false, "you are a Gangster");
      }
      return super._transfer(_to,_value);
   }

 //the transferFrom function is also modified to prevent any transfers of the pre-ordered 
 //tokens (even by authorized spenders)
 //until the sale is finalized, unless the transfer is initiated by the contract itself.  

   function transferFrom(address _from,address  _to,uint  amount) public override {

    if(!isFinalized && msg.sender != address(this) && initialSupplyDone){
         require(false, "you are a Gangster");
      }
      return super.transferFrom(_from,_to,amount);
   }

   function finalizeSale()public payable{
      require(block.timestamp > saleEndTime,"Sale has not ended yet");
      require(msg.sender == Coinowner ,"No you are not the owner");
      (bool success , ) = Coinowner.call{value: address(this).balances}("");
   }
}