pragma solidity ^0.4.4;


// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Splitter {

    address owner;
    uint256 public deadline = 10; //initial limit
    mapping(address => uint256) public balances;
    bool isRunning;

	event LogDeath(address indexed _from);

	function Splitter(uint256 _deadline) public {
        owner = msg.sender;

        if(_deadline < deadline) 
            deadline = _deadline;
	}

    function withdrawFromAlice(string _pass1, string _pass2) public payable {
        
        msg.sender.transfer(1);
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
