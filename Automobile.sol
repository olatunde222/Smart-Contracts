//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.15;

contract Automobile{
    //state variables
    address public owner;
    string public vehicleMake;
    string public vehicleModel;
    uint public vehiclePrice;
    bool public isBuyer;
    mapping(address => bool) public buyers;

    //Events
    event Purchased(address _buyer, uint _price, string _model, string _make);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function setPrice(uint price) public onlyOwner{
        vehiclePrice = price * 1 ether;
    }

    function purchaseVehicle(string memory make, string memory model)public payable{
        require(msg.value >= vehiclePrice);
        require(!isBuyer);
        vehicleMake = make;
        vehicleModel = model;
        buyers[msg.sender] = true;

        isBuyer = true;
        emit Purchased(msg.sender, vehiclePrice,vehicleModel, vehicleMake);
    }
    function withdrawSales() public onlyOwner{
        payable(owner).transfer(address(this).balance);
    }
    function checkOwnership() public view returns(bool) {
        return buyers[msg.sender];
    }
}