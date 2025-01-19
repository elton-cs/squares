#[starknet::interface]
trait IActions<T> {
    fn buy_coins(ref self: T, amount: u256);
    fn exit_square(ref self: T);
    fn enter_square_one(ref self: T);
    fn enter_square_two(ref self: T);
}

#[dojo::contract]
pub mod Actions {
    use super::{IActions};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    use squares::components::coins::CoinsComponent;
    use squares::components::bomba::BombaComponent;
    use squares::components::square::SquareComponent;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        coins: CoinsComponent::Storage,
        #[substorage(v0)]
        bomba: BombaComponent::Storage,
        #[substorage(v0)]
        square: SquareComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[event]
        CoinsEvent: CoinsComponent::Event,
        BombaEvent: BombaComponent::Event,
        SquareEvent: SquareComponent::Event,
    }

    component!(path: CoinsComponent, storage: coins, event: CoinsEvent);
    impl coins_impl = CoinsComponent::BaseImpl<ContractState>;

    component!(path: BombaComponent, storage: bomba, event: BombaEvent);
    impl bomba_impl = BombaComponent::BaseImpl<ContractState>;

    component!(path: SquareComponent, storage: square, event: SquareEvent);
    impl square_impl = SquareComponent::BaseImpl<ContractState>;

    fn dojo_init(ref self: ContractState) {
        let default_world = self.world_default();
        coins_impl::init_supply(default_world);
        bomba_impl::init_bomba(default_world);
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
            square_impl::exit_square(world);
        }

        fn enter_square_one(ref self: ContractState) {
            let mut world = self.world_default();
            bomba_impl::tick_bomba(world);
            square_impl::enter_square(world, 1);
        }

        fn enter_square_two(ref self: ContractState) {
            let mut world = self.world_default();
            bomba_impl::tick_bomba(world);
            square_impl::enter_square(world, 2);
        }
    }

    #[generate_trait]
    impl BaseImpl of BaseTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"squares")
        }
    }
}
