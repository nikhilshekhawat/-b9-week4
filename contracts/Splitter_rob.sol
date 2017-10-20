pragma solidity ^0.4.4;


// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Splitter {

    address owner;
    mapping(address => uint256) balances;

	event LogDeath(address indexed _from);
    event LogTransfer(address From, address To1, address To2, uint amount)

	function Splitter() public {
        owner = msg.sender;    
	}

    function splitFunds(address receiver1, address receiver2, uint256 amount) returns(bool success) {
        if(balance[msg.sender] < amount) return false;
        balance[msg.sender] -= amount;
        balance[receiver1] += amount/2;
        balance[receiver2] += amount/2;
        return false;
    }
    
    modifier onlyIfRunning {
        require(isRunning);
        _;
    }

    function kill() 
    public 
    onlyIfRunning 
    {
      if(msg.sender!=owner) revert();
      LogDeath(owner);
      owner.transfer(this.balance);
      selfdestruct(owner);
    }
}
