use dojo::world::WorldStorage;
use dojo::model::ModelStorage;
use starknet::ContractAddress;

use squares::models::counter::Counter;
use squares::models::coins::Coins;

#[derive(Copy, Drop)]
struct Store {
    world: WorldStorage,
}

#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    #[inline]
    fn read_counter(self: @Store, id: felt252) -> Counter {
        self.world.read_model(id)
    }

    #[inline]
    fn write_counter(ref self: Store, counter: @Counter) {
        self.world.write_model(counter)
    }

    #[inline]
    fn read_coins(self: @Store, owner: ContractAddress) -> Coins {
        self.world.read_model(owner)
    }

    #[inline]
    fn write_coins(ref self: Store, coins: @Coins) {
        self.world.write_model(coins)
    }
}