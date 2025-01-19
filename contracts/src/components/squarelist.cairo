#[starknet::component]
mod SquareListComponent {
    use starknet::{get_caller_address, ContractAddress};
    use core::num::traits::zero::Zero;
    use dojo::world::WorldStorage;
    use squares::store::{StoreTrait, Store};
    use squares::models::square::{SquareListTrait, SquareList};

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
        }

        fn new_player(world: WorldStorage, index: u8, player_address: ContractAddress) {
            let mut store = StoreTrait::new(world);

            let square_list = SquareListTrait::new(index, player_address);
            store.write_square_list(@square_list);
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

