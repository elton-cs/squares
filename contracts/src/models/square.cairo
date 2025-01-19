use starknet::{ContractAddress};
use core::num::traits::Zero;

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

    fn enter_square(ref self: Square, index: u8) {
        assert_index_within_bounds(index);
        self.square = index;
    }

    fn exit_square(ref self: Square) {
        self.square = 0;
    }
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
struct SquareList {
    #[key]
    square_index: u8,
    #[key]
    player: ContractAddress,
    previous_player: ContractAddress,
    next_player: ContractAddress,
}


#[generate_trait]
impl SquareListImpl of SquareListTrait {
    fn zero_list(index: u8) -> SquareList {
        assert_index_within_bounds(index);
        let zero_address: ContractAddress = Zero::zero();

        SquareList {
            square_index: index,
            player: zero_address,
            previous_player: zero_address,
            next_player: zero_address,
        }
    }

    fn new(index: u8, player: ContractAddress) -> SquareList {
        assert_index_within_bounds(index);
        let zero_address: ContractAddress = Zero::zero();

        SquareList {
            square_index: index,
            player,
            previous_player: zero_address,
            next_player: zero_address,
        }
    }

    fn reset(ref self: SquareList) {
        self.previous_player = Zero::zero();
        self.next_player= Zero::zero();
    }

    fn update_previous_player(ref self: SquareList, previous_player: ContractAddress) {
        assert_address_not_zero(previous_player);
        self.previous_player = previous_player;
    }

    fn update_next_player(ref self: SquareList, next_player: ContractAddress) {
        assert_address_not_zero(next_player);
        self.next_player = next_player;
    }

    fn update_square_index(ref self: SquareList, square_index: u8) {
        self.square_index = square_index;
    }

    fn is_in_list(self: @SquareList) -> bool {
        let zero_address: ContractAddress = Zero::zero();
        let prev_is_zero = *self.previous_player == zero_address;
        let next_is_zero = *self.next_player == zero_address;

        !(prev_is_zero && next_is_zero)
    }

    fn assert_is_reset(self: @SquareList) {
        let zero_address: ContractAddress = Zero::zero();
        assert(*self.previous_player == zero_address, 'previous player not reset');
        assert(*self.next_player == zero_address, 'next player not reset');
    }
}


// helper asserts
fn assert_address_not_zero(address: ContractAddress) {
    let zero_address = Zero::zero();
    assert(!(address == zero_address), 'Provided address cannot be 0x0');
}

fn assert_index_within_bounds(index: u8) {
    assert(index > 0, 'Selection cannot be 0');
    assert(index <= NUM_SQUARES, 'Selection is out of bounds');
}
