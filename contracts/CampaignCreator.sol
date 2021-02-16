pragma solidity ^0.5.0;

import './Campaign.sol';

contract CampaignCreator{
    Campaign [] public deployedCampaigns;
    
    function deployCampaign(uint minamount) public {
        Campaign newCampaign = new Campaign(minamount,msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeplyedCampaigns()public view returns(Campaign[] memory){
        return  deployedCampaigns;
    }
}