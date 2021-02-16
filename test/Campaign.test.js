const Campaign = artifacts.require('Campaign');
const CampaignCreator = artifacts.require('CampaignCreator');

contract(CampaignCreator, async(accounts)=>{

    let campaignCreator;
    let campaign;

    beforeEach(async()=>{
        //Loading contract
        campaignCreator = await CampaignCreator.new();

        //deploying contract Campaign
        await campaignCreator.deployCampaign('100',{from : accounts[0]});
        const addresses = await campaignCreator.getDeplyedCampaigns();
        const campaignAddress = addresses[0];

        //Getting the deployed Campaign
        campaign = await Campaign.at(campaignAddress);
    });

    describe('Campaigns',()=>{
        it('Successfull Deployment',()=>{
            assert.ok(campaignCreator.address);
            assert.ok(campaign.address);
        });
        it('Checking owner',async()=>{
            const owner = await campaign.manager();
            assert.equal(owner,accounts[0]);
        });

        it('Able to Contribute and Marked As Approver',async()=>{
            await campaign.contribute({from : accounts[1],value : '200'});
            const approverCount = await campaign.approversCount();
            let isContributor = await campaign.approvers(accounts[1]);
            assert.equal(approverCount,1);
            assert(isContributor);
        });

        it('Has a minimum contribution amount',async()=>{
            try{
                await campaign.contribute({from : account[2],value : '10'});
                assert(false);
            }
            catch(err){
                assert(err);
            }
        })

        it('Allow Manager to Make Requests',async()=>{
            await campaign.createRequests('Buy Starting Materials','100',accounts[3],{from : accounts[0]});
            const req = await campaign.requests(0);
            assert.equal('Buy Starting Materials',req.description);
        })

        it('Processing A Request',async()=>{
            await campaign.contribute({from : accounts[2],value : web3.utils.toWei('25','ether')});
            await campaign.createRequests('A',web3.utils.toWei('15','ether'),accounts[4],{from : accounts[0]});
            await campaign.approveRequest(0,{from : accounts[2]});
            await campaign.finalizeRequest(0,{from : accounts[0]});

            let balance  = await web3.eth.getBalance(accounts[4]);
            balance = web3.utils.toWei(balance,'ether');
            balance = parseFloat(balance);

            assert(balance>114);

        })

    })
});