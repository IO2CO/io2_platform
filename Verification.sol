
pragma solidity ^0.4.17;


/***
 *   IO2 Verification Contract
 *   
 *   This contract is base for co2 emission cut verification registration on IO2 platform
 *   Each co2 emission cut registration is for a specific period of time hold in days on contract. 
 *   For the specified amound of CO2 emission cut contract calculates the reward tokens 
 *   and invokes IO2 token contract to transfer calculated amount of IO2 tokens to polluting company.
 * 
 *   
 *   @author Hayrettin ERTURK
 *   version alpha-0.1
 * 
 ***/

contract  Verification {
    
    // Only IO2 owner account can register co2 emission cuts of the polluting companies on IO2 platform
    address io2OwningAddress;
    
    /**
     * CO2 Emission Cut struct
     * 
     * This struct holds the necessary and least amount of information to register a polluting company on blockchain
     */
    struct CO2EmissionCut { 
        // Polluting company whose co2 emission cut will be registered
        string companyName;
        // Polluting Companies address to pay tokens
        address companyAddress; 
        // We are using nanograms we don't want to go float Implementation anyways
        uint256 co2NanoGrams;
        // Time period of this emission cut in days, beginning back from registry date. 
        uint64 emissionCutPeriod;
        // Registration Date in timestamp
        uint32 registryDate; 
    }
    
    // List for each emission cut record
    CO2EmissionCut[] public co2EmissionCuts;
    
    // Every emission cut registeration is broadcast through "cutRegistered" event
    event cutRegistered(CO2EmissionCut cut);
    
    /**
     * Constructor function
     * 
     * As of now only defines the owner of the contract
     * 
     */
    function Verification() public {
        io2OwningAddress = msg.sender;
    }
    
    
    /** 
     * If a function is required to be only accessed by owner we use this modified 
     */
    modifier onlyOwner {                     
        if(msg.sender != io2OwningAddress) revert();
        _;
    }
    
    /**
     * 
     * Main registration function
     * 
     * @param companyAddress     Account address of company 
     * @param companyName        Name of the company
     * @param co2NanoGrams       Co2 amount to be registered in nano grams 
     * @param emissionCutPeriod  Amount of days that this emission cut is realized
     * @param registryDate       Emission cut reporting period end date as timestamp 
     * 
     */ 
    function registerCO2(address companyAddress,
                        string companyName, 
                        uint256 co2NanoGrams,
                        uint64 emissionCutPeriod, 
                        uint32 registryDate)
                        // Only IO2 platform able to register emission cuts
                        onlyOwner
                        public {
                            
        CO2EmissionCut memory newEmissionCut;
        
        newEmissionCut.companyName = companyName;
        newEmissionCut.companyAddress = companyAddress;
        newEmissionCut.co2NanoGrams = co2NanoGrams;
        newEmissionCut.emissionCutPeriod = emissionCutPeriod;
        newEmissionCut.registryDate = registryDate;
        
        co2EmissionCuts.push(newEmissionCut);
        
        
        // uint256 rewardTokenAmount = calculateRewardTokens(co2NanoGrams);
        
        // @TODO: Implementation will be after IO2 token contract implementation
        // releaseIO2Reward(newEmissionCut.companyAddress, rewardTokenAmount);
        
        // Release the event that a new company registered.
        cutRegistered(newEmissionCut);
        
    }
    
    /**
     * 
     * Public co2 emission cut query function.
     * 
     * Query emission cut by company account address and emission cut registry Date
     * 
     */ 
    function queryECutByCompanyAndDate(address companyAddress, uint32 registeryDate) 
                                        public constant returns(CO2EmissionCut record) {

        uint256 maxIters = co2EmissionCuts.length;
        
        // @TODO: Need to compare companyName.equal(co2EmissionCuts[i].companyName) == 0 on this form using string library
        
        for(uint256 i=0; i < maxIters; i++) {
            
            // Get every match to companies account
            if(co2EmissionCuts[i].companyAddress == companyAddress && 
               co2EmissionCuts[i].registryDate == registeryDate) {
                record = co2EmissionCuts[i];
            }
        }
        
        return record;
    }
    
    /***
     * 
     * @TODO: Implementation will be in accordance with IO2 token contract
     * 
     * Releases IO2 as a reward based on co2 emission cut Registration
     * 
    function releaseIO2Reward(address companyAddress, uint256 rewardToken) public {
        
    }
    ***/
    
    /***
     * 
     * @TODO: Implementation will be in accordance with IO2 token contract
     * 
     * Calculates reward IO2 amount based co2 emission cut in nanograms
     * e.g. 1 kg = 1 IO2
     * 
    function calculateRewardTokens(uint256 co2NanoGrams) {
        
    }
    ***/
    
}
