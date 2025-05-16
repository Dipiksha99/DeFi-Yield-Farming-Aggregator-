// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Project
 * @dev DeFi Yield Farming Aggregator that optimizes yield across multiple protocols
 */
contract Project is Ownable {
    using SafeERC20 for IERC20;
    
    struct Protocol {
        address contractAddress;
        string name;
        bool active;
    }
    
    struct Strategy {
        uint256 riskLevel; // 1-10, 10 being highest risk
        uint256 expectedAPY;
        address tokenAddress;
        uint256 protocolId;
    }
    
    mapping(uint256 => Protocol) public protocols;
    mapping(uint256 => Strategy) public strategies;
    mapping(address => mapping(uint256 => uint256)) public userInvestments; // user address => strategy id => amount
    
    uint256 public protocolCount;
    uint256 public strategyCount;
    uint256 public platformFee = 50; // basis points (0.5%)
    
    event Deposit(address indexed user, uint256 strategyId, uint256 amount);
    event Withdrawal(address indexed user, uint256 strategyId, uint256 amount);
    event RebalancedFunds(uint256 strategyId, uint256 oldProtocolId, uint256 newProtocolId);
    
    constructor() Ownable(msg.sender) {
        // Initialize with empty state
    }
    
    /**
     * @dev Deposit funds into a specific yield farming strategy
     * @param _strategyId The strategy ID to deposit into
     * @param _amount The amount of tokens to deposit
     */
    function deposit(uint256 _strategyId, uint256 _amount) external {
        require(_strategyId <= strategyCount && _strategyId > 0, "Invalid strategy ID");
        require(_amount > 0, "Amount must be greater than 0");
        
        Strategy memory strategy = strategies[_strategyId];
        IERC20 token = IERC20(strategy.tokenAddress);
        
        // Transfer tokens from user to contract
        token.safeTransferFrom(msg.sender, address(this), _amount);
        
        // Update user investment record
        userInvestments[msg.sender][_strategyId] += _amount;
        
        // Here we would interact with the protocol to deposit funds
        // This is simplified for this example
        
        emit Deposit(msg.sender, _strategyId, _amount);
    }
    
    /**
     * @dev Withdraw funds from a specific yield farming strategy
     * @param _strategyId The strategy ID to withdraw from
     * @param _amount The amount of tokens to withdraw
     */
    function withdraw(uint256 _strategyId, uint256 _amount) external {
        require(_strategyId <= strategyCount && _strategyId > 0, "Invalid strategy ID");
        require(_amount > 0, "Amount must be greater than 0");
        require(userInvestments[msg.sender][_strategyId] >= _amount, "Insufficient balance");
        
        Strategy memory strategy = strategies[_strategyId];
        IERC20 token = IERC20(strategy.tokenAddress);
        
        // Update user investment record
        userInvestments[msg.sender][_strategyId] -= _amount;
        
        // Here we would interact with the protocol to withdraw funds
        // This is simplified for this example
        
        // Transfer tokens from contract to user
        token.safeTransfer(msg.sender, _amount);
        
        emit Withdrawal(msg.sender, _strategyId, _amount);
    }
    
    /**
     * @dev Optimize yields by rebalancing funds between protocols
     * @param _strategyId The strategy ID to optimize
     * @param _newProtocolId The new protocol ID to move funds to
     */
    function optimizeYield(uint256 _strategyId, uint256 _newProtocolId) external onlyOwner {
        require(_strategyId <= strategyCount && _strategyId > 0, "Invalid strategy ID");
        require(_newProtocolId <= protocolCount && _newProtocolId > 0, "Invalid protocol ID");
        require(protocols[_newProtocolId].active, "New protocol is not active");
        
        uint256 oldProtocolId = strategies[_strategyId].protocolId;
        strategies[_strategyId].protocolId = _newProtocolId;
        
        // Here we would handle the logic to move funds between protocols
        // This is simplified for this example
        
        emit RebalancedFunds(_strategyId, oldProtocolId, _newProtocolId);
    }
}
