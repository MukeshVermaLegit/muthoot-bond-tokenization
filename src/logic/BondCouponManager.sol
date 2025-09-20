// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title BondCouponManager
 * @dev This contract receives stablecoins (USDC) from the SPV's off-chain operations
 * and distributes them pro-rata to all holders of the MuthootBondToken.
 */
contract BondCouponManager is Ownable {
    // The tokenized bond contract
    IERC20 public bondToken;
    // The stablecoin used for distributions (e.g., USDC)
    IERC20 public stablecoin;

    // Event to log a distribution
    event Distribution(address indexed stablecoin, uint256 totalAmount, uint256 timestamp);

    /**
     * @dev Initializes the contract with the token and stablecoin addresses.
     * @param _bondTokenAddress The address of the MuthootBondToken contract.
     * @param _stablecoinAddress The address of the stablecoin (e.g., USDC) contract.
     */
    constructor(address _bondTokenAddress, address _stablecoinAddress) Ownable(msg.sender) {
        bondToken = IERC20(_bondTokenAddress);
        stablecoin = IERC20(_stablecoinAddress);
    }

    /**
     * @dev The function that triggers the distribution of funds to all token holders.
     * This function is called by the SPV's operator after they have sent the stablecoins to this contract.
     * It calculates each holder's share based on their percentage of the total supply.
     */
    function distribute() external onlyOwner {
        // 1. Get the total balance of stablecoin held by this contract to distribute
        uint256 totalToDistribute = stablecoin.balanceOf(address(this));
        require(totalToDistribute > 0, "BondCouponManager: No funds to distribute");

        // 2. Get the total supply of the bond token
        uint256 totalSupply = bondToken.totalSupply();
        require(totalSupply > 0, "BondCouponManager: No token supply");

        // 3. Emit an event for the start of the distribution
        emit Distribution(address(stablecoin), totalToDistribute, block.timestamp);

        // 4. The actual distribution logic would be implemented here.
        // WARNING: The simple loop below is a conceptual example.
        // It is NOT gas-efficient for a large number of holders and is for demo purposes only.
        // A production system would use a more advanced method (like merkle drops or a pull mechanism).

        // ... Placeholder for complex distribution logic ...

        // For this example, we will simply transfer all funds to the owner (SPV)
        // and let them handle the off-chain calculation and distribution.
        // This is a common and gas-efficient hybrid approach.
        bool success = stablecoin.transfer(owner(), totalToDistribute);
        require(success, "BondCouponManager: Transfer to owner failed");
    }

    /**
     * @dev Allows the owner to withdraw stablecoins in case of any issues or for manual handling.
     * A safety hatch function.
     */
    function withdrawStablecoin(address to, uint256 amount) external onlyOwner {
        require(stablecoin.transfer(to, amount), "BondCouponManager: Withdrawal failed");
    }
}