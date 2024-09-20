//SPDX-License-Identifier: MIT


// This is a fundMe smart contract that will allow someon eto create a fundme account for a project
// This contract keeps track of Funders/Contributors to the project
// This contract allows a contributor to withdraw funds from the contact if the fundme period has not expired
//
pragma solidity ^0.8.10;

contract FundMe{

    // State Variables
    address creator;
    uint256 public goalAmount;
    uint256 public deadline;
    uint256 public totalContribution;
    bool public isFunded;
    bool public isCompleted;

    // [] Mapping the address of the donor to the amount donated
    mapping (address => uint) public contributors;

    // Emitted Events
    event goalReached(uint256 totalContribution);
    event fundTransfer(address donor, uint256 amount);
    event deadlineReached(uint256 deadline);
    event withdraw(address _creator, uint256 amount);


    // Constructor
    constructor(uint256 goalAmountInEther, uint256 durationInMinute){
        creator = msg.sender;
        goalAmount = goalAmountInEther * 1 ether;
        deadline = block.timestamp + durationInMinute * 1 minutes;
    }

    // Modifiers
    modifier onlyCreator{
        require(msg.sender == creator, "Only the Creator can access this function");
        _;
    }

    //Function For Contribution To the Project 
    function contribute() public payable {
        require(block.timestamp < deadline, "Opps! Funding period has Elapsed.");
        require(!isCompleted, "Funding is Completed");
        uint256 contribution = msg.value;
        contributors[msg.sender] = contribution;
        totalContribution += contribution;

        if(totalContribution >= goalAmount){
            isFunded = true;
            emit goalReached(totalContribution);
        }
        emit fundTransfer(msg.sender, contribution);
    }

    // Function to allow the creator to withdraw funds
    function withdrawFunds() public onlyCreator{
        require(isFunded, "Funding goal has not been reached");
        require(!isCompleted, "Funding is Completed");
        isCompleted = true;
        payable(creator).transfer(address(this).balance);
        emit withdraw(msg.sender, totalContribution);
    }

    // Function to allow contributors to get refund
    function getRefund() public {
        require(block.timestamp >= deadline, "Funding Period has not ended");
        require(!isFunded, "Goal has been reached");
        require(contributors[msg.sender] > 0, "No contributions made");
        uint256 contribution = contributors[msg.sender];
        contributors[msg.sender] = 0;
        totalContribution -= contribution;
        payable(msg.sender).transfer(contribution);
        emit fundTransfer(msg.sender, contribution);
    }

    // function for Getting Balance
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    

    // Function to Extend the Funding Deadline
    function extendDeadline(uint256 durationInMinutes) public onlyCreator{
        deadline += durationInMinutes * 1 minutes;
    }

    
}

