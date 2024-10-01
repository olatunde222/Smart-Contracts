//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Banking {
    address  public owner;
    mapping (address => uint256) balances;

    modifier onlyOwner{
        require(msg.sender == owner, "You are not the Owner of this Account");
        _;
    }

    constructor (){
         owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "You cannot make a deposit less a zero amount");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount)public onlyOwner{
        require(amount <= balances[msg.sender], "Insufficient Funds");
        require(amount > 0, "Amount has to be more than zero");
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;
    }

    function transfer(address payable recipientAddress, uint256 transferAmount) public onlyOwner{
        require(transferAmount <= balances[msg.sender], "Insufficient Funds");
        require(transferAmount > 0, "Transfer Amount hsould be more than zero");
        balances[msg.sender] -= transferAmount;
        balances[recipientAddress] += transferAmount;
    }

    function getBalances() public view returns(uint256){
        return balances[msg.sender];
    }

    function grantAccess(address payable newOwner) public onlyOwner {
        owner = newOwner;
    }
    function revokeAccess(address payable newOwner) public onlyOwner{
        require(newOwner != owner, "Cannot revoke access of the current owner");
        owner = payable(msg.sender);
    }

    function destruct() public onlyOwner{
        
    }
}

