#[starknet::component]
mod SquareListComponent {
    use starknet::{get_caller_address, ContractAddress};
    use core::num::traits::zero::Zero;
    use dojo::world::WorldStorage;
    use squares::store::{StoreTrait, Store};
    use squares::models::square::{
        SquareListTrait, SquareList, ListLengthTrait, ListLength, SquareTrait, Square
    };

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl BaseImpl<T, +HasComponent<T>> of BaseTrait<T> {
        // only for dojo_init
        fn init_empty_square_list(world: WorldStorage, index: u8) {
            let mut store = StoreTrait::new(world);

            let square_list = SquareListTrait::zero_list(index);
            store.write_square_list(@square_list);

            let list_length = ListLengthTrait::new(index, 0);
            store.write_list_length(@list_length);
        }

        fn new_player(world: WorldStorage, index: u8, player_address: ContractAddress) {
            let mut store = StoreTrait::new(world);

            let square_list = SquareListTrait::new(index, player_address);
            store.write_square_list(@square_list);
        }

        fn get_player_square_index(world: WorldStorage, player_address: ContractAddress) -> u8 {
            let mut store = StoreTrait::new(world);
            let square = store.read_square(player_address);
            square.square
        }

        fn set_player_square_index(
            world: WorldStorage, player_address: ContractAddress, index: u8
        ) {
            let mut store = StoreTrait::new(world);
            let mut square = store.read_square(player_address);
            square.square = index;
            store.write_square(@square);
        }

        fn increment_list_length(world: WorldStorage, index: u8) {
            let mut store = StoreTrait::new(world);
            let mut list_length = store.read_list_length(index);
            list_length.increment();
            store.write_list_length(@list_length);
        }

        fn decrement_list_length(world: WorldStorage, index: u8) {
            let mut store = StoreTrait::new(world);
            let mut list_length = store.read_list_length(index);
            assert(list_length.length > 0, 'List length is already 0');
            list_length.decrement();
            store.write_list_length(@list_length);
        }

        fn get_list_length(world: WorldStorage, index: u8) -> u32 {
            let mut store = StoreTrait::new(world);
            let list_length = store.read_list_length(index);
            list_length.length
        }

        // player callable
        fn join_square_list(world: WorldStorage, index: u8, player_address: ContractAddress) {
            let mut store = StoreTrait::new(world);
            let zero_address = Zero::zero();

            let mut zero_node = store.read_square_list(index, zero_address);
            let mut player_node = store.read_square_list(index, player_address);

            if zero_node.next_player == zero_address {
                zero_node.update_next_player(player_node.player);
                zero_node.update_previous_player(player_node.player);

                player_node.update_previous_player(zero_node.player);
                player_node.update_next_player(zero_node.player);
            } else {
                let mut existing_node = store.read_square_list(index, zero_node.next_player);

                zero_node.update_next_player(player_node.player);

                player_node.update_previous_player(zero_node.player);
                player_node.update_next_player(existing_node.player);

                existing_node.update_previous_player(player_node.player);
            }

            store.write_square_list(@zero_node);
            store.write_square_list(@player_node);
        }

        fn leave_square_list(world: WorldStorage, index: u8, player_address: ContractAddress) {
            let mut store = StoreTrait::new(world);
            let zero_address = Zero::zero();

            let mut zero_node = store.read_square_list(index, zero_address);
            let mut player_node = store.read_square_list(index, player_address);

            if player_node.is_in_list() {
                let mut previous_node = store.read_square_list(index, player_node.previous_player);
                let mut next_node = store.read_square_list(index, player_node.next_player);

                previous_node.update_next_player(player_node.next_player);
                next_node.update_previous_player(player_node.previous_player);
                player_node.reset();

                store.write_square_list(@previous_node);
                store.write_square_list(@next_node);
                store.write_square_list(@player_node);
            } else {
                if zero_node.next_player == player_node.player {
                    zero_node.reset();
                    store.write_square_list(@zero_node);
                }
            }
        }
    }
}

