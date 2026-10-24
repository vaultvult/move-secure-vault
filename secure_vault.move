module secure_vault::vault {
    use std::signer;
    use std::error;
    use aptos_framework::coin::{Self, Coin};

    const E_NOT_OWNER: u64 = 1;
    const E_INSUFFICIENT_BALANCE: u64 = 2;

    // The Vault resource holds the user's coins.
    struct Vault<phantom CoinType> has key {
        coins: Coin<CoinType>,
    }

    // The OwnerCapability proves ownership and allows withdrawals.
    struct OwnerCapability has key, store {
        vault_addr: address,
    }

    public entry fun create_vault<CoinType>(account: &signer, initial_deposit: Coin<CoinType>) {
        let owner = signer::address_of(account);
        assert!(!exists<Vault<CoinType>>(owner), error::already_exists(1));

        let vault = Vault<CoinType> {
            coins: initial_deposit,
        };

        let cap = OwnerCapability {
            vault_addr: owner,
        };

        move_to(account, vault);
        move_to(account, cap);
    }

    public entry fun withdraw<CoinType>(
        account: &signer, 
        amount: u64
    ) acquires Vault, OwnerCapability {
        let owner = signer::address_of(account);
        
        // Verify the caller holds the correct OwnerCapability
        let cap = borrow_global<OwnerCapability>(owner);
        assert!(cap.vault_addr == owner, error::permission_denied(E_NOT_OWNER));

        let vault = borrow_global_mut<Vault<CoinType>>(owner);
        assert!(coin::value(&vault.coins) >= amount, error::invalid_argument(E_INSUFFICIENT_BALANCE));

        let extracted_coins = coin::extract(&mut vault.coins, amount);
        coin::deposit(owner, extracted_coins);
    }
}
