pragma solidity ^0.4.4;


// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Splitter {

    address owner;
    address public alice;
    address public bob;
    address public carol;
    
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	function Splitter(address _alice, address _bob, address _carol) {
        owner = tx.origin;
        alice = _alice;
        bob = _bob;
        carol = _carol;
	}

    function () payable {
        if(msg.sender==alice) {
            bob.send(msg.value/2);
            carol.send(msg.value/2);
        }
    }
    

	function sendCoin(address receiver, uint amount) returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}

    function kill() public onlyowner {
      owner.send(this.balance);
      selfdestruct(owner);
    }
}
