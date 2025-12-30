// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() external payable {
        require(msg.value == 1 ether, "Please pay exactly 1 ether");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "Only manager can view balance");
        return address(this).balance;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function pickWinner() external {
        require(msg.sender == manager, "Only manager can pick winner");
        require(players.length >= 3, "No players yet");

        uint r=random();
        uint index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance()); 

        // Reset for next round
        players = new address payable[](0);
    }
}