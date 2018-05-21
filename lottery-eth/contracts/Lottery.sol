pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether);//minimum amount for entry into lottery function
        players.push(msg.sender);//copy the address to the players array
    }

    function random() private view returns (uint){
        return uint(sha3(block.difficulty, now, players));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance);
        players = new address[](0);//empty the players array
    }

    modifier restricted(){
        require(msg.sender == manager);
        _;
    }//custom modifier to limit code duplication

    function getPlayers() public view returns (address[]){
        return players;
    }
}