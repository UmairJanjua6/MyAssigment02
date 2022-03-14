// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MYERC1155 is ERC1155{
    using Counters for Counters.Counter;
    bytes32 private constant TOKEN_COST_ROLE = keccak256("TOKEN_COST_ROLE");
    uint private _tokenPrice;
    Counters.Counter private _tokenId;
    address owner;
    constructor(address rolePrice) ERC1155("") {
        owner = msg.sender;
        _setupRole(DEFAULT_ADMIN_ROLE, owner);
        _setupRole(TOKEN_COST_ROLE, rolePrice);
    }

    function setTokenPrice(uint _price) external onlyRole(TOKEN_COST_ROLE) {
        require(_price > 0, "Need price of token");
        _tokenPrice = _price;
    }

    function tokenMint() external payable {
        
        uint tokensPrice = _tokenPrice * 100 * 5;
        require(msg.value == tokensPrice, "You dont have enogh amount");

        for(uint i = 0; i < 5; ++i){
            uint tokens = _tokenId.current();
            _tokenId.increment();
            _mint(msg.sender, tokens, 100, "");
        }
    }

    function tokenBurn(address from, uint id, uint amount) external onlyRole(DEFAULT_ADMIN_ROLE){
        _burn(from, id, amount);
    }
    
}
