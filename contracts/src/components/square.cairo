#[starknet::component]
mod SquareComponent {
    use starknet::{get_caller_address};
    use squares::models::square::{SquareTrait, Square};
    use squares::store::{StoreTrait, Store};
    use dojo::world::WorldStorage;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl BaseImpl<T, +HasComponent<T>> of BaseTrait<T> {
        fn init_square(world: WorldStorage) {
            let mut store = StoreTrait::new(world);
            let caller = get_caller_address();

            let caller_square = SquareTrait::new(caller);
            store.write_square(@caller_square);
        }

        fn enter_square(world: WorldStorage, square_pos: u8) {
            let mut store = StoreTrait::new(world);
            let caller = get_caller_address();
            let _caller_coins = store.read_coins(caller);
            // caller_coins.assert_not_zero();

            let mut caller_square = store.read_square(caller);
            caller_square.enter_square(square_pos);

            store.write_square(@caller_square);
        }

        fn exit_square(world: WorldStorage) {
            let mut store = StoreTrait::new(world);
            let caller = get_caller_address();

            let mut caller_square = store.read_square(caller);
            caller_square.exit_square();

            store.write_square(@caller_square);
        }
    }
}

