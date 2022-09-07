// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Land_Registeration{


// state variables
    address payable  inspector;
    uint Ether = 1 ether;
    uint landCount = 0;
    uint sellercount = 0;
    uint buyercount = 0;

    constructor() {
        inspector = payable  (msg.sender);
    }

    modifier  ins(){
        require(msg.sender == inspector, "You are not inspector");
        _;
    }

    // Land Detail
    struct Land{
        uint LandId;
        string Area;
        string City;
        string state;
        uint LandPrice;
        uint ProertyId;
        address Owner;
    }

    // Buyer details
    struct Buyer{
        address Id;
        string Name;
        uint Age;
        string City;
        uint CNIC;
        string Email;
    }

    // Seller Details
    struct Seller{
        address Id;
        string Name;
        uint Age;
        string City;
        uint CNIC;
        string Email;
    }

    // Inspector Detail
    struct Inspector{
        address Id;
        string Name;
        uint Age;
        string Designation; 
    }
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4    owner
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 seller
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db Buyer

    // structs mapping
    mapping(uint => Land)public  LandsMap;
    mapping(address => Inspector)public InspectorMap;
    mapping(address => Buyer)public BuyersMap;
    mapping(address => Seller)public  SellersMap;

    // Verification Mapping
    mapping(uint => bool)public VerificationLandMap;
    mapping(address => bool)public VerificationSellerMap; 
    mapping(address => bool)public VerificationBuyerMap; 
    mapping(address => bool)public VerificationInspectorMap; 

    // Registered Land, Seller, Buyer and Mappings
    mapping(address => bool)public RegisteredSellerMap;
    mapping(address => bool)public RegisteredBuyerMap; 
    
    // Approve inspector by admin
    function verifyIns(address id)public ins {
        VerificationInspectorMap[id] = true;
    }

    // check inspector Verified or not
    function isInsVerified(address id)public view returns (bool){
        if(VerificationInspectorMap[id]){
            return true;
        }
        else {return false;}
    }

    // verify seller
    function verifySeller(address id)public ins {
        VerificationSellerMap[id] = true;
    }

    // remove Seller
    function removeSeller(address id) public ins {
        RegisteredSellerMap[id] = false;
        VerificationSellerMap[id] = false;
    }  

    // check seller verified or not
    function isSellerVerified(address id) public view returns(bool){
        if(VerificationSellerMap[id]){
            return true;
        }
        else {return false;}
    }

    // verify Buyer
    function verifyBuyer(address id)public ins {
        VerificationBuyerMap[id] = true;
    }

    // remove Buyer
    function removeBuyerr(address id) public ins {
        RegisteredBuyerMap[id] = false;
        VerificationBuyerMap[id] = false;
    }  

    // check Buyer verified or not
    function isBuyerVerified(address id) public view returns(bool){
        if(VerificationBuyerMap[id]){
            return true;
        }
        else {return false;}
    }

    // verify Land
    function verifyLand(uint id) public  ins {
        VerificationLandMap[id] = true;
    }

    // check land veririfed or not
    function isLandVerified(uint id) public view returns(bool){
        if(VerificationLandMap[id]){
            return true;
        }
        else {return false;}
    }

    // Register Inspector
    function RegInspector(address id, string memory name, uint age, string memory designation) public{
        InspectorMap[id] = Inspector(id, name, age, designation);
      
    }

    // register Seller
    function SellerReg(address id, string memory name, uint age, string memory city, uint cnic, string memory email )public {
        require(RegisteredBuyerMap[id] == false && RegisteredBuyerMap[msg.sender] == false, "You are not register as a seller");
        RegisteredSellerMap[id] = true;
        SellersMap[id] = Seller(msg.sender,name, age, city, cnic, email);
    }

    // Update Seller
    function SellerUpdate(address id, string memory name, uint age, string memory city, uint cnic, string memory email )public {
        require(SellersMap[msg.sender].Id == msg.sender , "You don't have account");
        SellersMap[id].Name = name;
        SellersMap[id].Age = age;
        SellersMap[id].City = city;
        SellersMap[id].CNIC = cnic;
        SellersMap[id].Email = email;
        
    }

    // register Buyer
    function BuyerReg(address id, string memory name, uint age, string memory city, uint cnic, string memory email )public {
        require(RegisteredSellerMap[id] == false && RegisteredSellerMap[msg.sender] == false, "You are not register as a seller");
        RegisteredBuyerMap[id] = true;
        BuyersMap[id] = Buyer(msg.sender,name, age, city, cnic, email);
    }

    // Update Buyer
    function BuyerUpdate(address id, string memory name, uint age, string memory city, uint cnic, string memory email )public {
        require(BuyersMap[msg.sender].Id == msg.sender , "You don't have account");
        BuyersMap[id].Name = name;
        BuyersMap[id].Age = age;
        BuyersMap[id].City = city;
        BuyersMap[id].CNIC = cnic;
        BuyersMap[id].Email = email; 
    }

     // Reg Land
    function RegLand(uint id, string memory area, string memory city, string memory state, uint landprice, uint propertyId ) public {
        require(isSellerVerified(msg.sender), "You can not register land ");
        landprice = landprice *  Ether;
        LandsMap[id] = Land(id, area, city, state, landprice, propertyId, msg.sender);
        landCount++;
    }

    // Get Land Owner
    function GetOwner(uint id)public  view returns (address){
        return LandsMap[id].Owner;
    }

    // Get Land City 
    function GetCity(uint id) public view returns (string memory){
        return LandsMap[id].City;
    }

    // Get Land Price 
    function GetPrice(uint id) public view returns (uint){
        return LandsMap[id].LandPrice;
    }


    // Buyer Buy a land and transfer Ownership
    function PaymentMethod(uint id ) public payable returns(bool){
        require(VerificationBuyerMap[msg.sender] == true && VerificationLandMap[id] ==true, "You are not able to buy this land");
        require(LandsMap[id].LandPrice == msg.value, "please pay exact price");
        payable(LandsMap[id].Owner).transfer(msg.value);
        LandsMap[id].Owner =payable( msg.sender);
        return true;
    }

    // transfer Ownership
    function TransferOwnership(uint id , address payable newOwner) public {
        LandsMap[id].Owner = newOwner;
    }
   
}
