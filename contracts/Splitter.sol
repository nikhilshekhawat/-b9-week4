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
    
	event LogDeath(address indexed _from);

	function Splitter(address _alice, address _bob, address _carol) public {
        owner = msg.sender;
        alice = _alice;
        bob = _bob;
        carol = _carol;
	}

    function () payable {
        if(msg.sender==alice) {
            bob.transfer(msg.value/2);
            carol.transfer(msg.value - msg.value/2);
        }
    }

    function kill() public {
      if(msg.sender!=owner) revert();
      LogDeath(owner);
      owner.transfer(this.balance);
      selfdestruct(owner);
    }
}
