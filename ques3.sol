pragma solidity 0.8.18;

contract CompanyContract 
{
    address admin;
    mapping(address => uint256) public userLevel;
    mapping(uint256 => uint256) public limit;
    mapping(address => uint256) public userSpending;

    event TransactionLimitExceeded(address user, uint256 amount);

    constructor() 
    {
        admin = msg.sender;
        limit[1] = 100; // Level 1 spending limit
        limit[2] = 200; // Level 2 spending limit
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function addUser(address _user, uint256 _level) external onlyAdmin {
        userLevel[_user] = _level;
    }

    function updateLevelLimit(uint256 _level, uint256 _limit)
        external
        onlyAdmin
    {
        limit[_level] = _limit;
    }

    function spend(uint256 _amount) external {
        if (msg.sender != admin) {
            require(
                _amount <= limit[userLevel[msg.sender]],
                "Transaction limit exceeded."
            );

            userSpending[msg.sender] += _amount;
            if (userSpending[msg.sender] > limit[userLevel[msg.sender]]) {
                emit TransactionLimitExceeded(
                    msg.sender,
                    userSpending[msg.sender]
                );
            }
        } else userSpending[msg.sender] += _amount;
    }

    receive() external payable {}
}
