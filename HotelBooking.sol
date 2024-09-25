//SPDX-License-Identifier:MIT 


pragma solidity ^0.8.10;

contract Hotel{
    // Enum with two state to keep track of the rooms
    enum roomStatus{Vacant, Occupied}
    roomStatus CurrentStatus;

    // variables
    address public owner;
    address public occupant;

    //Event
    event booked(address _occupant, uint _value);

    //contructor
    constructor(){
        owner = msg.sender;
        CurrentStatus = roomStatus.Vacant;
    }

    //modifiers
    modifier onlyOwner{
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    modifier onlyVacant {
        require(CurrentStatus == roomStatus.Vacant, "Room Occupied");
        _;
    }
    modifier price(uint _price){
        require(msg.value >= _price, "Value below the room price");
        _;
    }

    // Booking function Method 1
    receive() external payable onlyVacant price(2 ether){ 
        payable(owner).transfer(msg.value);
        CurrentStatus = roomStatus.Occupied;
        occupant = msg.sender;
        emit booked(msg.sender, msg.value);
    }

    // Booking function Method 2
    function bookRoom()public payable onlyVacant price(2 ether) {
        CurrentStatus = roomStatus.Occupied;
        occupant = msg.sender;
        emit booked(msg.sender, msg.value);
    }

    // Withdraw Function
    function withdraw() public onlyOwner{
        payable(owner).transfer(address(this).balance);
    }
}