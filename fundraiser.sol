//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Crowdfunding {
    address public owner;
    uint public counter;

    constructor() {

        owner = msg.sender;
        counter = 0;
    }

    struct proposal {
        string name;
        uint id;
        address owner;
        uint target;
        uint duration;
        uint balance;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    proposal[] public proposals;


    function createProposal(string calldata Name, uint Target, uint  Duration) public {
        uint _id = counter;

        proposals.push(proposal(Name, _id, msg.sender, Target, Duration, 0));

        counter++;
    }

    function checkProposalTarget(uint _id) public view returns(uint) {
        
        uint proposalTarget = proposals[_id].target;
        return proposalTarget;
    }

    function fundProposal(/*string memory Name,*/ uint _id) public payable {
        
        //require(proposals[_id].name == Name, "Proposal Name and Id do not match"); //returns error
        require( proposals[_id].balance < proposals[_id].target, "The target has been met");

        proposals[_id].balance = proposals[_id].target - msg.value;
    }
    
    function checkProposalBalance(uint _id) public view returns(uint) {
        uint proposalBalance = proposals[_id].balance;
        return proposalBalance;
    }

    function cashoutProposal(uint _id) public onlyOwner {
        require( proposals[_id].balance == proposals[_id].target, "The target is yet to be met");
        payable(proposals[_id].owner).transfer(proposals[_id].balance);
    }
}