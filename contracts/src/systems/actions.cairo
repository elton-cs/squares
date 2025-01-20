#[starknet::interface]
trait IActions<T> {
    fn buy_coins(ref self: T, amount: u256);
    fn start_game(ref self: T);
    fn end_game(ref self: T);
    fn exit_square(ref self: T);
    fn enter_square_one(ref self: T);
    fn enter_square_two(ref self: T);
    fn read_tick(self: @T) -> u32;
    fn flip_square(ref self: T);
}

#[dojo::contract]
pub mod Actions {
    use super::{IActions};
    use starknet::{get_caller_address};
    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    use squares::components::coins::CoinsComponent;
    use squares::components::bomba::BombaComponent;
    use squares::components::square::SquareComponent;
    use squares::components::squarelist::SquareListComponent;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        coins: CoinsComponent::Storage,
        #[substorage(v0)]
        bomba: BombaComponent::Storage,
        #[substorage(v0)]
        square: SquareComponent::Storage,
        #[substorage(v0)]
        square_list: SquareListComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[event]
        CoinsEvent: CoinsComponent::Event,
        BombaEvent: BombaComponent::Event,
        SquareEvent: SquareComponent::Event,
        SquareListEvent: SquareListComponent::Event,
    }

    component!(path: CoinsComponent, storage: coins, event: CoinsEvent);
    impl coins_impl = CoinsComponent::BaseImpl<ContractState>;

    component!(path: BombaComponent, storage: bomba, event: BombaEvent);
    impl bomba_impl = BombaComponent::BaseImpl<ContractState>;

    component!(path: SquareComponent, storage: square, event: SquareEvent);
    impl square_impl = SquareComponent::BaseImpl<ContractState>;

    component!(path: SquareListComponent, storage: square_list, event: SquareListEvent);
    impl square_list_impl = SquareListComponent::BaseImpl<ContractState>;

    fn dojo_init(ref self: ContractState) {
        let default_world = self.world_default();
        coins_impl::init_supply(default_world);
        bomba_impl::init_bomba(default_world);

        square_list_impl::init_empty_square_list(default_world, 1);
        square_list_impl::init_empty_square_list(default_world, 2);
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn buy_coins(ref self: ContractState, amount: u256) {
            let mut world = self.world_default();
            coins_impl::buy_coins(world, amount);
        }


        fn exit_square(ref self: ContractState) {
            let mut world = self.world_default();
            bomba_impl::tick_bomba(world);
            // square_impl::exit_square(world);

            let player_address = get_caller_address();
            square_list_impl::leave_square_list(world, 1, player_address);
            square_list_impl::leave_square_list(world, 2, player_address);
        }

        // fn flip_square(ref self: ContractState) { // get player square index
        // // use that value to join the other square list

        // }

        fn start_game(ref self: ContractState) {
            let mut world = self.world_default();
            let player_address = get_caller_address();
            square_list_impl::new_player(world, 1, player_address);

            let square_index = square_list_impl::get_player_square_index(world, player_address);
            assert(square_index == 0, 'Player already in game');
            square_list_impl::join_square_list(world, 1, player_address);
            square_list_impl::increment_list_length(world, 1);
            square_list_impl::set_player_square_index(world, player_address, 1);

            bomba_impl::tick_bomba(world);
        }

        fn end_game(ref self: ContractState) {
            let mut world = self.world_default();
            let player_address = get_caller_address();
            let square_index = square_list_impl::get_player_square_index(world, player_address);
            assert(square_index == 1 || square_index == 2, 'Player not in game');
            square_list_impl::leave_square_list(world, square_index, player_address);
            square_list_impl::decrement_list_length(world, square_index);
            square_list_impl::set_player_square_index(world, player_address, 0);

            bomba_impl::tick_bomba(world);
        }

        fn flip_square(ref self: ContractState) {
            let mut world = self.world_default();
            let player_address = get_caller_address();

            let mut index = square_list_impl::get_player_square_index(world, player_address);
            assert(index == 1 || index == 2, 'Player not in game');
            if index == 1 {
                square_list_impl::join_square_list(world, 2, player_address);
                square_list_impl::increment_list_length(world, 2);
                square_list_impl::decrement_list_length(world, 1);
                index = 2;
            } else {
                square_list_impl::join_square_list(world, 1, player_address);
                square_list_impl::increment_list_length(world, 1);
                square_list_impl::decrement_list_length(world, 2);
                index = 1;
            }

            square_list_impl::set_player_square_index(world, player_address, index);
            bomba_impl::tick_bomba(world);
        }

        fn enter_square_one(ref self: ContractState) {
            let mut world = self.world_default();
            bomba_impl::tick_bomba(world);
            // square_impl::enter_square(world, 1);

            let player_address = get_caller_address();
            square_list_impl::join_square_list(world, 1, player_address);
        }

        fn enter_square_two(ref self: ContractState) {
            let mut world = self.world_default();
            bomba_impl::tick_bomba(world);
            // square_impl::enter_square(world, 2);

            let player_address = get_caller_address();
            square_list_impl::join_square_list(world, 2, player_address);
        }

        fn read_tick(self: @ContractState) -> u32 {
            bomba_impl::read_tick(self.world_default())
        }
    }

    #[generate_trait]
    impl BaseImpl of BaseTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"squares")
        }
    }
}
