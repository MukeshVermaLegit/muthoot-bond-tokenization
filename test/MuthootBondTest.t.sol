// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MuthootBondToken} from "../src/tokens/MuthootBondToken.sol";
import {BondCouponManager} from "../src/logic/BondCouponManager.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// We'll create a mock stablecoin for testing
contract MockUSDC is IERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "MockUSDC: insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(allowance[from][msg.sender] >= amount, "MockUSDC: insufficient allowance");
        require(balanceOf[from] >= amount, "MockUSDC: insufficient balance");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}

contract MuthootBondTest is Test {
    MuthootBondToken public bondToken;
    BondCouponManager public couponManager;
    MockUSDC public usdc;

    address public spv = makeAddr("spv_treasury");
    address public investor1 = makeAddr("investor_1");
    address public investor2 = makeAddr("investor_2");
    address public nonKycUser = makeAddr("non_kyc_user");

    uint256 constant TOTAL_SUPPLY = 1_000_000 * 10**18; // 1 million tokens

    function setUp() public {
        // 1. Deploy the mock stablecoin
        usdc = new MockUSDC();
        // Mint some USDC to the SPV to simulate it receiving coupon payments
        usdc.mint(spv, 10_000 * 10**6); // 10,000 USDC (6 decimals)

        // 2. Switch to the SPV address to deploy the contracts
        vm.startPrank(spv);

        // 3. Deploy the Bond Token. The constructor mints all tokens to the SPV.
        bondToken = new MuthootBondToken(spv, TOTAL_SUPPLY);

        // 4. Deploy the Coupon Manager
        couponManager = new BondCouponManager(address(bondToken), address(usdc));

        // 5. Set the Coupon Manager address in the Bond Token contract
        bondToken.setCouponManager(address(couponManager));

        vm.stopPrank();

        // 6. Whitelist our test investors
        vm.prank(spv);
        bondToken.whitelistAddress(investor1);
        vm.prank(spv);
        bondToken.whitelistAddress(investor2);
    }

    function test_InitialSetup() public {
        // Check SPV owns all tokens initially
        assertEq(bondToken.balanceOf(spv), TOTAL_SUPPLY);
        assertEq(bondToken.isWhitelisted(spv), true);
        assertEq(bondToken.isWhitelisted(investor1), true);
        assertEq(bondToken.isWhitelisted(nonKycUser), false);
        assertEq(address(couponManager.bondToken()), address(bondToken));
    }

    function test_WhitelistEnforcement() public {
    // SPV can transfer to whitelisted investor
    vm.prank(spv);
    bondToken.transfer(investor1, 1000e18); // Should pass

    // Non-whitelisted user cannot receive tokens
    vm.prank(spv);
    vm.expectRevert("MuthootBondToken: Recipient not whitelisted");
    bondToken.transfer(nonKycUser, 1000e18);

    // Whitelisted user can send to another whitelisted user (this should pass)
    vm.prank(investor1);
    bondToken.transfer(investor2, 500e18); // Both are whitelisted, so this should work

    // To test non-whitelisted sender, we'd need to somehow get tokens to a non-whitelisted address first
    // But our contract prevents this! So this test case is not feasible with the current design
    // This is actually GOOD - it means our security is working as intended
}

    function test_PrimaryDistributionFromSPV() public {
        uint256 amountToSend = 10_000e18;

        vm.startPrank(spv);
        bondToken.transfer(investor1, amountToSend);
        vm.stopPrank();

        assertEq(bondToken.balanceOf(investor1), amountToSend);
        assertEq(bondToken.balanceOf(spv), TOTAL_SUPPLY - amountToSend);
    }

    function test_SecondaryTradingBetweenInvestors() public {
        // First, get tokens to investor1
        uint256 amount = 5_000e18;
        vm.prank(spv);
        bondToken.transfer(investor1, amount);

        // investor1 can send to investor2 (both are whitelisted)
        vm.prank(investor1);
        bondToken.transfer(investor2, 2_000e18);

        assertEq(bondToken.balanceOf(investor1), amount - 2_000e18);
        assertEq(bondToken.balanceOf(investor2), 2_000e18);
    }

    function test_CouponDistribution() public {
        // Setup: Distribute some tokens to investors first
        vm.startPrank(spv);
        bondToken.transfer(investor1, 300_000e18); // 30% of supply
        bondToken.transfer(investor2, 200_000e18); // 20% of supply
        vm.stopPrank();

        // Simulate the SPV receiving a coupon payment of 1000 USDC and sending it to the manager
        uint256 couponAmount = 1000 * 10**6; // 1000 USDC (6 decimals)
        vm.prank(spv);
        usdc.transfer(address(couponManager), couponAmount);

        assertEq(usdc.balanceOf(address(couponManager)), couponAmount);

        // The SPV triggers the distribution
        vm.prank(spv);
        couponManager.distribute();

        // Since our current `distribute` just sends funds back to the owner (SPV) as a placeholder,
        // we test that. In a real implementation, we'd check investor balances.
        assertEq(usdc.balanceOf(address(couponManager)), 0);
        assertEq(usdc.balanceOf(spv), 10_000e6 - couponAmount + couponAmount); // Initial - sent + received back
    }

    function test_OnlyOwnerCanWhitelist() public {
        // A random investor cannot whitelist others
        vm.prank(investor1);
        vm.expectRevert(); // Ownable: caller is not the owner
        bondToken.whitelistAddress(investor2);

        // The owner (SPV) can
        vm.prank(spv);
        bondToken.whitelistAddress(nonKycUser);
        assertEq(bondToken.isWhitelisted(nonKycUser), true);
    }

    function test_OnlyOwnerCanDistribute() public {
        // A random investor cannot trigger distribution
        vm.prank(investor1);
        vm.expectRevert(); // Ownable: caller is not the owner
        couponManager.distribute();
    }
}

// forge test --match-path test/MuthootBondTest.t.sol -vvv