use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
struct Square {
    #[key]
    owner: ContractAddress,
    square: u8,
}

const NUM_SQUARES: u8 = 2;

#[generate_trait]
impl SquareImpl of SquareTrait {
    fn new(owner: ContractAddress) -> Square {
        Square { owner, square: 0 }
    }

    fn enter_square(ref self: Square, square: u8) {
        assert(square > 0, 'Selection cannot be 0 square');
        assert(square <= NUM_SQUARES, 'Selection is out of bounds');
        self.square = square;
    }

    fn exit_square(ref self: Square) {
        self.square = 0;
    }
}
