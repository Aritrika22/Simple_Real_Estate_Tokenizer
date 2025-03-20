// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateTokenizer {
    struct Property {
        string name;
        uint256 totalShares;
        uint256 pricePerShare;
        address owner;
    }

    mapping(uint256 => Property) public properties;
    mapping(uint256 => mapping(address => uint256)) public ownership;
    uint256 public propertyCounter;

    event PropertyTokenized(uint256 propertyId, string name, uint256 totalShares, uint256 pricePerShare, address owner);
    event SharesPurchased(uint256 propertyId, address buyer, uint256 shares);

    function tokenizeProperty(string memory _name, uint256 _totalShares, uint256 _pricePerShare) public {
        propertyCounter++;
        properties[propertyCounter] = Property(_name, _totalShares, _pricePerShare, msg.sender);
        ownership[propertyCounter][msg.sender] = _totalShares;
        emit PropertyTokenized(propertyCounter, _name, _totalShares, _pricePerShare, msg.sender);
    }

    function buyShares(uint256 _propertyId, uint256 _shares) public payable {
        require(properties[_propertyId].totalShares >= _shares, "Not enough shares available");
        require(msg.value == _shares * properties[_propertyId].pricePerShare, "Incorrect payment amount");
        
        ownership[_propertyId][msg.sender] += _shares;
        ownership[_propertyId][properties[_propertyId].owner] -= _shares;
        emit SharesPurchased(_propertyId, msg.sender, _shares);
    }

    function getOwnership(uint256 _propertyId, address _owner) public view returns (uint256) {
        return ownership[_propertyId][_owner];
    }
}
