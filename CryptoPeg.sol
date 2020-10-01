// =========================== ERC20 Token Contract =================

/* CryptoPeg.sol
   Modified from https://ethereum.org/token.
   Solidity Code to Implement Peg Protocol from
   ``Currency Stability Using Blockchain Technology,'' by Routledge and Zetlin-Jones
   This version: 10/1/20
*/



pragma solidity >=0.4.22 <0.6.0;



contract owned {

    address public owner;

    constructor() public {

        owner = msg.sender;

    }

    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }


    function transferOwnership(address newOwner) onlyOwner public {

        owner = newOwner;

    }

}


interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }



contract TokenERC20 {

    string public name;

    string public symbol;

    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Burn(address indexed from, uint256 value);

    constructor(

        uint256 initialSupply,

        string memory tokenName,

        string memory tokenSymbol

    ) public {

        totalSupply = initialSupply;

        balanceOf[msg.sender] = totalSupply;

        name = tokenName;

        symbol = tokenSymbol;

    }

    function _transfer(address _from, address _to, uint _value) internal {

        require(_to != address(0x0));

        require(balanceOf[_from] >= _value);

        require(balanceOf[_to] + _value > balanceOf[_to]);

        uint previousBalances = balanceOf[_from] + balanceOf[_to];

        balanceOf[_from] -= _value;

        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

    }


    function transfer(address _to, uint256 _value) public returns (bool success) {

        _transfer(msg.sender, _to, _value);

        return true;

    }

    function approve(address _spender, uint256 _value) public

        returns (bool success) {

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        require(_value <= allowance[_from][msg.sender]);     // Check allowance

        allowance[_from][msg.sender] -= _value;

        _transfer(_from, _to, _value);

        return true;

    }

    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)

        public

        returns (bool success) {

        tokenRecipient spender = tokenRecipient(_spender);

        if (approve(_spender, _value)) {

            spender.receiveApproval(msg.sender, _value, address(this), _extraData);

            return true;

        }

    }

    function burn(uint256 _value) public returns (bool success) {

        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;

        totalSupply -= _value;

        emit Burn(msg.sender, _value);

        return true;

    }


    function burnFrom(address _from, uint256 _value) public returns (bool success) {

        require(balanceOf[_from] >= _value);

        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;

        allowance[_from][msg.sender] -= _value;

        totalSupply -= _value;

        emit Burn(_from, _value);

        return true;

    }

}

contract MyAdvancedToken is owned, TokenERC20 {

    uint256 public sellPrice;

    uint256 public buyPrice;
    
    address public trader1;
    
    address public trader2;
    
    address public trader3;
    
    int public sellCounter = 0;

    mapping (address => bool) public frozenAccount;

    event FrozenFunds(address target, bool frozen);

    constructor(

        uint256 initialSupply,
        
        string memory tokenName,

        string memory tokenSymbol

    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}


    function _transfer(address _from, address _to, uint _value) internal {

        require (_to != address(0x0));

        require (balanceOf[_from] >= _value);

        require (balanceOf[_to] + _value >= balanceOf[_to]);

        require(!frozenAccount[_from]);

        require(!frozenAccount[_to]);

        balanceOf[_from] -= _value;

        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner public {

        balanceOf[target] += mintedAmount;

        totalSupply += mintedAmount;

        emit Transfer(address(0), address(this), mintedAmount);

        emit Transfer(address(this), target, mintedAmount);

    }


    function freezeAccount(address target, bool freeze) private {
    
        frozenAccount[target] = freeze;
        
        emit FrozenFunds(target, freeze);

    }
    

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {

        sellPrice = newSellPrice;

        buyPrice = newBuyPrice;

    }

    function setTraders(address newtrader1, address newtrader2, address newtrader3) onlyOwner public {

        trader1 = newtrader1;

        trader2 = newtrader2;

        trader3 = newtrader3;

    }


    function buy() payable public {

        uint amount = msg.value / buyPrice;

        _transfer(address(this), msg.sender, amount);

    }


    function freezeall() onlyOwner public {
    
        freezeAccount(trader1, true);

        freezeAccount(trader2, true);
        
        freezeAccount(trader3, true);        
        
    }


    function runpeg() onlyOwner public {
    
        address myAddress = address(this);
    
        sellPrice = 1000000000000000000;
        
        freezeAccount(trader1, false);
        
        transferOwnership(myAddress);
        
    }
    
    function runfreeze(address thisaddress) private {
        
        address myAddress = thisaddress;

        sellCounter += 1;
                
        if (sellCounter==1) {
        
            freezeAccount(trader1, true);
        
            freezeAccount(trader2, false);
        
            if (balanceOf[myAddress] == 10) {
                
               sellPrice = 800000000000000000;
               
            }
        
        } else if (sellCounter == 2) {
        
            freezeAccount(trader2, true);
            
            freezeAccount(trader3, false);
            
            if (balanceOf[myAddress] == 10) {
            
                sellPrice = 1000000000000000000;
                
            }
        }
        
        }
    
    function sell(uint256 amount) public {

        address myAddress = address(this);
        
        require(myAddress.balance >= amount * sellPrice);

        _transfer(msg.sender, address(this), amount);
        
        // It's important to do this transfer last to avoid recursion attacks.

        msg.sender.transfer(amount * sellPrice);

        runfreeze(myAddress);

    }
    
}
