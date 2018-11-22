pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 { 

    struct Star { 
        string name; 
        string story;
        string ra; // right ascend
        string dec; // declination
        string mag; // magnitude

    }

    mapping(uint256 => Star) public tokenIdToStarInfo; 
    mapping(uint256 => uint256) public starsForSale;
    mapping(bytes32 => uint256) public  coordinatesHashToTokenId;

    function createStar(string _name, string _story, string _ra, string _dec, string _mag, uint256 _tokenId) public { 

        // input validations
        require(bytes(_ra).length != 0 &&
                bytes(_dec).length != 0 &&
                bytes(_mag).length != 0 &&
                _tokenId != 0, "ERROR: ra, dec, mag, tokenId can not be empty");

        // check if tokenId already exists
        require(bytes(tokenIdToStarInfo[_tokenId].ra).length == 0, "ERROR: TokenId already exists.");

        // star should not  already exist
        require(!checkIfStarExist(_ra, _dec, _mag), "ERROR: The star with these coordinates already exists");

        Star memory newStar = Star(_name, _story, _ra, _dec, _mag);

        bytes32 hash = generateCoordinatesHash(_ra, _dec, _mag);

        coordinatesHashToTokenId[hash] = _tokenId;

        tokenIdToStarInfo[_tokenId] = newStar;

        _mint(msg.sender, _tokenId);
    
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable { 
        require(starsForSale[_tokenId] > 0);
        
        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);
        
        starOwner.transfer(starCost);

        if(msg.value > starCost) { 
            msg.sender.transfer(msg.value - starCost);
        }
    }

    function generateCoordinatesHash(string ra, string dec, string mag) public pure returns (bytes32){

        return keccak256(abi.encodePacked(ra, dec, mag));
    }

    

   function checkIfTokenExist(uint _tokenId) public view returns(bool){

            if(compareStrings(tokenIdToStarInfo[_tokenId].name,  '')) return false;
            else return true;
   }

   function compareStrings (string a, string b) view returns (bool){
       return keccak256(a) == keccak256(b);
   }


    function checkIfStarExist(string ra, string dec, string mag) public view returns(bool){
        bytes32 hash = generateCoordinatesHash(ra, dec, mag);
        if(coordinatesHashToTokenId[hash] == 0){
            return false;
        }else{
            return true;
        }


    }

    function mint(uint256 tokenId) public {
        _mint(msg.sender, tokenId);
    }

    function starsForSale(uint256 _tokenId) public view returns (uint256)  {
        return starsForSale[_tokenId];
    }

    function tokenIdToStarInfo(uint256 _tokenId) public view returns (string, string, string, string, string){

         return (tokenIdToStarInfo[_tokenId].name,  tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].mag);
    }
}