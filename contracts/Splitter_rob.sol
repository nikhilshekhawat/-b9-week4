pragma solidity ^0.4.4;


// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Splitter_rob {

    address owner;
    mapping(address => uint256) public balances;
    bool isRunning;
    
	event LogDeath(address indexed _from);
    event LogTransfer(address From, address To1, address To2, uint amount);
    event LogWithdraw(address client, uint amount);
    event Unauthorised(address caller, string msg);
    event FundsSiezed(address caller, uint amount);

	function Splitter_rob() public {
        owner = msg.sender;    
	}

    function splitFunds(address receiver1, address receiver2) 
    onlyIfRunning 
    payable
    returns(bool success) 
    {
        if(balances[msg.sender] < msg.value) return false;
        balances[msg.sender] -= msg.value;
        balances[receiver1] += msg.value/2;
        balances[receiver2] += msg.value/2;
        LogTransfer(msg.sender, receiver1, receiver2, msg.value);
        return false;
    }

    function withdraw(uint256 amount) 
    payable 
    returns(bool success)
    {
        if(balances[msg.sender] < amount) return false;
        msg.sender.transfer(amount);
        LogWithdraw(msg.sender, amount);
        return true;
    }
    
    function kill() 
    public 
    onlyIfRunning 
    {
      if(msg.sender!=owner) revert();
      require(!isRunning);
      LogDeath(owner);
      owner.transfer(this.balance);
      selfdestruct(owner);
    }

    function stopRunning() public 
    onlyOwner 
    onlyIfRunning 
    returns(bool success) 
    { 
        isRunning = false; 
        return true; 
    }
    
    function resume() public onlyOwner returns(bool success) { isRunning = true; return true; }
    
    function seizeFunds() public onlyOwner returns(bool success) {
        require(!isRunning);
        FundsSiezed(msg.sender, this.balance);
        owner.transfer(this.balance);
        return true;
    }


    //Modifiers
     modifier onlyIfRunning {
        require(isRunning);
        _;
    }

     modifier onlyOwner {
        if (msg.sender == owner) 
            _;
        else 
            Unauthorised(msg.sender, "onlyOwner");
    }
}
