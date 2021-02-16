pragma solidity ^0.5.0;

contract Campaign{
    
    struct Request{
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    address public manager;
    mapping(address => bool) public approvers;
    uint public minimumamount;
    Request[] public requests;
    uint public approversCount;
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint minimum,address creator)public{
        manager  = creator;
        minimumamount = minimum;
        approversCount =0;
    }
    
    function contribute ()public payable{
        require(msg.value>minimumamount);
        if(approvers[msg.sender] == false)
        {
            approvers[msg.sender] = true;
            approversCount++;
        }

    }
    
    
    //CONCEPT OF storage and memory
    //used for 2 things
    //1st
    //storage - for variables that are avaible btw function calls eg manager approvers
    //memeory - temporary variables like minimum
    //2nd
    //storage - used for creating a reference onject
    //memory - used for creating a copy (video 11,12)
    function createRequests(string memory description , uint value , address payable recipient)public restricted{
    
        Request memory newReq = Request({
           description : description,
           value : value,
           recipient : recipient,
           complete : false,
           approvalCount : 0
        });
        
        requests.push(newReq);
    }
    
    //for approving the request by contributors
    function approveRequest(uint index) public{
        
        Request storage rq = requests[index]; // a reference to the request at index - index
        require(approvers[msg.sender]);
        require(!rq.approvals[msg.sender]); //checking already voted or not
        
        rq.approvalCount++;
        rq.approvals[msg.sender] = true;
    }
    
    function finalizeRequest(uint index) public restricted{
        Request storage rq = requests[index];
        require(!rq.complete);
        require(rq.approvalCount > approversCount/2);
        
        rq.recipient.transfer(rq.value);
        rq.complete = true;
    }

    function getSummary() public view returns(uint,uint,uint,uint,address){
        return (
            minimumamount,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }
    
    function getRequestsCount()public view returns(uint){
        return requests.length;
    }
}
