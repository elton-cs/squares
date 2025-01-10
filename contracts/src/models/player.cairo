use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
struct Player {
    #[key]
    owner: ContractAddress,
    square: u8,
}

const NUM_SQUARES: u8 = 2;

#[generate_trait]
impl PlayerImpl of PlayerTrait {
    fn new(owner: ContractAddress) -> Player {
        Player { owner, square: 0 }
    }

    fn enter_square(ref self: Player, square: u8) {
        assert(square > 0, 'Selection is out of bounds');
        assert(square <= NUM_SQUARES, 'Selection is out of bounds');
        self.square = square;
    }

    fn exit_square(ref self: Player) {
        self.square = 0;
    }
}
