// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title MuthootBondToken
 * @dev This contract represents a tokenized version of the Muthoot Finance Oct'26 bond.
 * It includes a whitelist to enforce KYC/AML checks before any transfer can occur.
 * The owner (the SPV's operator) is the only one who can mint tokens and manage the whitelist.
 */
contract MuthootBondToken is ERC20, Ownable {
    // The wallet address of the BondCouponManager contract that distributes payments
    address public couponManager;

    // Mapping to track which addresses are whitelisted (passed KYC)
    mapping(address => bool) public isWhitelisted;

    // Events for logging whitelist changes
    event AddressWhitelisted(address indexed account);
    event AddressRemovedFromWhitelist(address indexed account);

    /**
     * @dev Constructor mints the initial supply to the SPV's treasury wallet.
     * @param _spvTreasury The address of the SPV's wallet that will initially hold all tokens.
     * @param _totalSupply The total number of tokens to mint, representing the total bond value.
     */
    constructor(address _spvTreasury, uint256 _totalSupply)
        ERC20("Muthoot Finance Oct 2026 Bond", "MFRL-OCT26")
        Ownable(_spvTreasury)
    {
        // The SPV is set as the owner of the contract via Ownable(_spvTreasury)
        _mint(_spvTreasury, _totalSupply);
        isWhitelisted[_spvTreasury] = true; // Automatically whitelist the SPV
    }

    /**
     * @dev Sets the address of the Coupon Manager contract. Can only be called by the owner (SPV).
     * @param _couponManager The address of the deployed BondCouponManager contract.
     */
    function setCouponManager(address _couponManager) external onlyOwner {
        couponManager = _couponManager;
        isWhitelisted[_couponManager] = true; // Whitelist the manager to receive tokens for distributions
    }

    /**
     * @dev Adds an investor's address to the whitelist. Called by the SPV operator after off-chain KYC.
     * @param _investor The address of the investor to whitelist.
     */
    function whitelistAddress(address _investor) external onlyOwner {
        isWhitelisted[_investor] = true;
        emit AddressWhitelisted(_investor);
    }

    /**
     * @dev Removes an address from the whitelist.
     * @param _investor The address to remove.
     */
    function removeFromWhitelist(address _investor) external onlyOwner {
        isWhitelisted[_investor] = false;
        emit AddressRemovedFromWhitelist(_investor);
    }

    /**
     * @dev OVERRIDE: Hook into the ERC20 transfer logic to check whitelist status before any transfer.
     * @param from The sender address.
     * @param to The recipient address.
     * @param amount The amount of tokens to transfer.
     */
    function _update(address from, address to, uint256 amount) internal virtual override {
        // Allow minting (from is zero address) and burning (to is zero address)
        if (from != address(0) && to != address(0)) {
            require(isWhitelisted[from], "MuthootBondToken: Sender not whitelisted");
            require(isWhitelisted[to], "MuthootBondToken: Recipient not whitelisted");
        }
        super._update(from, to, amount);
    }
}
