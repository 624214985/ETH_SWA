// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {

    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint public rate = 100;  //赎回率

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

    //购买代币
    function buyTokens() public payable {

        //计算购买代币的数量  msg.value用户使用以太币的数量
        uint tokenAmount = msg.value * rate;

        //确保EthSwap交易所有足够的代币供用户购买
        require(token.balanceOf(address(this)) >= tokenAmount);

        //转移代币到这个用户
        token.transfer(msg.sender, tokenAmount);

        //Emit an event
        emit TokensPurchased(msg.sender,address(token),tokenAmount,rate);
    }

    //出售代币
    function sellTokens(uint _amount) public {
        //用户出售代币数量不能超出他们所持有的数量
        require(token.balanceOf(msg.sender) >= _amount);

        //计算要赎回的以太币金额
        uint entherAmount = _amount / rate;

        //确保EthSwap拥有足够的Ether
        require(address(this).balance >= entherAmount);

        //执行销售
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(entherAmount);

        // Emit an event
        emit TokensSold(msg.sender, address(token), _amount, rate);
    }
    
}