# Muthoot Bond Tokenization Project

[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)](https://getfoundry.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains the smart contracts for a tokenized bond system. The core innovation is combining a robust on-chain compliance mechanism (whitelisting) with a traditional legal structure (Special Purpose Vehicle) to create a digital representation of a real-world bond that enforces regulatory requirements like KYC/AML at the smart contract level.

## 📋 System Architecture

The tokenization process bridges the traditional financial world with the blockchain digital world through a Special Purpose Vehicle (SPV).

![Tokenization Architecture](docs/architecture.png)

### Architecture Components

**Real World Legal & Trust**
- **Muthoot Finance Ltd.**  
  - Issuer
  - Issues Bond
  - Pays Coupons/Principal

- **Bond Registry**  
  - KFin Technologies/Link Intime
  - Records SPV as Legal Owner

- **RBI & SEBI**  
  - Regulators
  - Governs & Oversees

- **Custodian Bank**  
  - Holds Certificate
  - Holds Bond for SPV

**Special Purpose Vehicle**
- **SPV Trust/Company**  
  - Legal Owner of Bond
  - The Legal Bridge

**Blockchain Digital Ecosystem**
- **KYC/AML Provider**  
  - NSDL e-Gov, Karza
  - Provides On-Chain Verification

- **Smart Contracts**  
  - MFRL-OCT26 Token & Bond Logic
  - Manages Transfers
  - Distributes Payments

- **Whitelisted Investor Wallets**  
  - Hold Tokenized Bonds
  - Trade Tokens

- **ATS Trading Platform**  
  - For Secondary Trading
  - Settles Trades

## 🚀 Key Features

- **Regulatory Compliance:** On-chain whitelisting for KYC/AML enforcement
- **SPV Structure:** Legal bridge between traditional finance and blockchain
- **Automated Distributions:** Smart contract-based coupon payments
- **Comprehensive Testing:** Full test suite with Foundry


## Explanation 

Step-by-Step Explanation of the Tokenization Process
The process follows two parallel tracks: actions in the Real World (light blue) and actions on the Blockchain (light purple), connected by the SPV (light orange).

Phase 1: Setup & Primary Issuance
Step 1 & 2: Establishing Legal Ownership (Real World)

The Special Purpose Vehicle (SPV) is created as a legal entity (Trust/Company). It is the cornerstone of the entire structure.

The SPV uses investor funds to purchase the physical "Muthoot Oct'26" bond.

The Bond Registry (e.g., KFin Technologies) is updated to reflect the SPV as the new legal owner of the bond. All future coupon and principal payments from Muthoot will be sent to the SPV's bank account.

Step 3: Safekeeping the Asset (Real World)

The physical bond certificate (or electronic record) is held by a regulated Custodian Bank for safekeeping on behalf of the SPV.

Step 4 & 5: The Regulatory Framework (Real World)

RBI & SEBI provide the essential regulatory framework. Their rules govern how the SPV must operate, how investors are protected, and how the ATS (trading platform) must function. Their oversight ensures the entire process is compliant.

Step 6: Creating the Digital Twin (Bridge → Blockchain)

The SPV instructs its technology partner to deploy the Smart Contracts on the chosen blockchain.

The "Token Contract" mints the entire supply of digital tokens (e.g., MFRL-OCT26), which represent beneficial ownership of the bond. These tokens are initially held by the SPV.

Step 7: Investor Onboarding (Blockchain)

Before any investor can buy or hold the tokens, they must undergo KYC/AML checks with a verified provider.

Once approved, the investor's blockchain wallet address is added to the smart contract's whitelist. This is a critical compliance feature that prevents unauthorized trading.

Step 8: Primary Distribution (Blockchain)

The SPV transfers tokens to the whitelisted wallets of investors in exchange for fiat currency (via traditional banking).

The investors are now the beneficial owners of the bond. The SPV holds the legal title on their behalf.

Phase 2: Ongoing Operations & Secondary Trading
Step 9 & 10: Secondary Market Trading (Blockchain)

Investors can now trade the MFRL-OCT26 tokens among themselves on a regulated Alternative Trading System (ATS).

The ATS ensures every trade is compliant. When a trade occurs, it instructs the Smart Contract to transfer tokens from the seller's whitelisted wallet to the buyer's whitelisted wallet.

Phase 3: Coupon Payments & Maturity (The Cash Flow)
The Cycle (Not numbered in diagram, but follows black arrows):

Real World: Muthoot Finance pays a coupon to the Bond Registry, which is then sent to the SPV's bank account.

The Bridge: The SPV's operator converts the INR to a stablecoin (e.g., USDC) and sends it to the Bond Logic Smart Contract.

Blockchain: The Smart Contract automatically and instantly distributes the stablecoin pro-rata to all current MFRL-OCT26 token holders in their wallets.

At maturity, the same process occurs for the final principal repayment, after which the tokens have no further value.
