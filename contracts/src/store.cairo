use dojo::world::WorldStorage;
use dojo::model::ModelStorage;
use starknet::ContractAddress;

use squares::models::coins::Coins;
use squares::models::bomba::Bomba;
use squares::models::square::{Square, SquareList};

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
    fn read_coins(self: @Store, owner: ContractAddress) -> Coins {
        self.world.read_model(owner)
    }

    #[inline]
    fn write_coins(ref self: Store, coins: @Coins) {
        self.world.write_model(coins);
    }

    #[inline]
    fn read_bomba(self: @Store, id: bool) -> Bomba {
        self.world.read_model(id)
    }

    #[inline]
    fn write_bomba(ref self: Store, bomba: @Bomba) {
        self.world.write_model(bomba);
    }

    #[inline]
    fn read_square(self: @Store, owner: ContractAddress) -> Square {
        self.world.read_model(owner)
    }

    #[inline]
    fn write_square(ref self: Store, square: @Square) {
        self.world.write_model(square);
    }

    #[inline]
    fn read_square_list(self: @Store, index: u8, player: ContractAddress) -> SquareList {
        self.world.read_model((index, player))
    }

    #[inline]
    fn write_square_list(ref self: Store, square_list: @SquareList) {
        self.world.write_model(square_list);
    }
}
