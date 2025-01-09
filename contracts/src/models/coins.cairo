use starknet::{ContractAddress};
use core::num::traits::Zero;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
struct Coins {
    #[key]
    owner: ContractAddress,
    balance: u256,
}

const MAX_SUPPLY: u256 = 1_000_000_000_000_000_000_000;
const MIN_POINTS: u256 = 0;

#[generate_trait]
impl CoinsImpl of CoinsTrait {
    fn new(owner: ContractAddress, balance: u256) -> Coins {
        Coins { owner, balance }
    }

    fn max_supply() -> Coins {
        Coins { owner: Zero::<ContractAddress>::zero(), balance: MAX_SUPPLY }
    }

    fn add(ref self: Coins, amount: u256) {
        assert(amount > MIN_POINTS, 'Amount must be greater than 0');
        assert(self.balance + amount <= MAX_SUPPLY, 'Max supply reached');
        self.balance += amount;
    }

    fn subtract(ref self: Coins, amount: u256) {
        assert(amount > MIN_POINTS, 'Amount must be greater than 0');
        assert(self.balance >= amount, 'Insufficient balance');
        self.balance -= amount;
    }

    fn multiply(ref self: Coins, amount: u256) {
        assert(amount > MIN_POINTS, 'Amount must be greater than 0');
        assert(self.balance * amount <= MAX_SUPPLY, 'Max supply reached');
        self.balance *= amount;
    }

    fn divide(ref self: Coins, amount: u256) {
        assert(amount > MIN_POINTS, 'Amount must be greater than 0');
        assert(self.balance / amount <= MAX_SUPPLY, 'Max supply reached');
        self.balance /= amount;
    }
}

#[cfg(test)]
mod tests {
    use super::{Coins, CoinsTrait};
    use core::num::traits::Zero;

    #[test]
    fn test_divide_even() {
        let mut coins = CoinsTrait::new(Zero::zero(), 100);
        coins.divide(10);
        assert(coins.balance == 10, 'balance is wrong');
    }

    #[test]
    fn test_divide_odd_with_remainder() {
        let mut coins = CoinsTrait::new(Zero::zero(), 100);
        coins.divide(4);
        assert(coins.balance == 25, 'balance is wrong');
        coins = CoinsTrait::new(Zero::zero(), 101);
        coins.divide(4);
        assert(coins.balance == 25, 'balance is wrong');
        coins = CoinsTrait::new(Zero::zero(), 102);
        coins.divide(4);
        assert(coins.balance == 25, 'balance is wrong');
        coins = CoinsTrait::new(Zero::zero(), 103);
        coins.divide(4);
        assert(coins.balance == 25, 'balance is wrong');

        coins = CoinsTrait::new(Zero::zero(), 104);
        coins.divide(4);
        assert(coins.balance == 26, 'balance is wrong');
    }

    #[test]
    #[should_panic]
    fn test_divide_zero() {
        let mut coins = CoinsTrait::new(Zero::zero(), 100);
        coins.divide(0);
    }
}
