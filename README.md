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
- **Secondary Trading:** Prepared for regulated ATS integration
- **Comprehensive Testing:** Full test suite with Foundry

## 📁 Project Structure
