# Move Secure Vault 🛡️

![Move](https://img.shields.io/badge/Move-000000?style=for-the-badge&logo=move&logoColor=white)
![Security](https://img.shields.io/badge/Security-Smart_Contracts-red?style=for-the-badge)

## Overview
This repository demonstrates a secure, capability-based asset vault implemented in **Move** for the Aptos/Sui ecosystem. 

Move's linear type system prevents assets from being duplicated or accidentally destroyed (preventing classic EVM-style double-spends). However, logic flaws in access control can still lead to asset theft. This module uses a `OwnerCapability` resource to prove ownership before allowing withdrawals.

## 🔒 Security Features
- **Capability-Based Access Control:** Withdrawals are strictly gated behind the possession of the `OwnerCapability` resource.
- **Phantom Types:** The `Vault<CoinType>` is generic, ensuring type safety for whatever coin is deposited.
- **No Global State Reliance:** The vault state is stored directly under the owner's address, eliminating the need for complex global storage maps that are prone to key-collision attacks.

## 🚀 Usage
To run the tests, ensure you have the Aptos CLI installed, then run:
```bash
aptos move test
