// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable public manager;
    address payable[] public players;
    address [] public allWinners;
    constructor(){
        manager = payable(msg.sender);
    }

    // require statements are statement when condition inside require statement is fullfill then only next line will get executed other wise execution gets over at that line
    function recieve() external payable{
        require(msg.sender!=manager,"You are manager so you cannot compete in lottery");
        require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random()internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }

    function pickWinner()public{
        require(msg.sender == manager);
        require(players.length>=3);

        uint r = random();
        uint index = r%players.length;
        
        address payable winner;
        winner = players[index];
        uint winnerPrice = getBalance();
        uint managerComission = winnerPrice/10;
        
        manager.transfer(managerComission);
        winner.transfer(winnerPrice-managerComission);
        
        allWinners.push(winner);

        players = new address payable[](0);
    }

}