#[starknet::component]
mod CoinsComponent {
    use starknet::{get_caller_address};
    use squares::models::coins::{CoinsTrait, Coins};
    use squares::store::{StoreTrait, Store};
    use dojo::world::WorldStorage;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl BaseImpl<T, +HasComponent<T>> of BaseTrait<T> {
        fn init_supply(world: WorldStorage) {
            let mut store = StoreTrait::new(world);
            let mut supply_coins = CoinsTrait::max_supply();
            store.write_coins(@supply_coins);
        }

        fn buy_coins(world: WorldStorage, amount: u256) {
            let mut store = StoreTrait::new(world);

            let caller = get_caller_address();
            let zero_address = Zero::zero();
            let mut supply_coins = store.read_coins(zero_address);
            let mut caller_coins = store.read_coins(caller);

            supply_coins.subtract(amount);
            caller_coins.add(amount);

            store.write_coins(@supply_coins);
            store.write_coins(@caller_coins);
        }
    }
}

