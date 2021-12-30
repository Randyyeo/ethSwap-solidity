pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint public rate = 100;

    event TokensPurchased(
        address account,
        address token,
        uint amount,
        uint rate
    );

    event TokensSold(
        address account,
        address token,
        uint amount,
        uint rate
    );

    constructor(Token _token) public {
        token = _token;

    }

    function buyTokens() public payable{
        // Redemption rate = # of tokens they receive for 1 Ether
        // Amount of Ethereum * Redemption Rate
        uint tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount);
        token.transfer(msg.sender, tokenAmount);

        // Emit an event
        emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint _amount) public{
        // User cannot sell more tokens than they have
        require(token.balanceOf(msg.sender) >= _amount);
        uint etherAmount = _amount / rate;
        token.transferFrom(msg.sender, address(this), _amount);
        require(address(this).balance >= etherAmount);
        msg.sender.transfer(etherAmount);

        emit TokensSold(msg.sender, address(token), _amount, rate);
    }
}