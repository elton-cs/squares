#[starknet::interface]
trait IActions<T> {
    fn buy_coins(ref self: T, amount: u256);
}

#[dojo::contract]
pub mod Actions {
    use super::{IActions};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    use squares::components::coins::CoinsComponent;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        coins: CoinsComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[event]
        CoinsEvent: CoinsComponent::Event,
    }

    component!(path: CoinsComponent, storage: coins, event: CoinsEvent);
    impl coins_impl = CoinsComponent::BaseImpl<ContractState>;

    fn dojo_init(ref self: ContractState) {
        coins_impl::init_supply(self.world_default());
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn buy_coins(ref self: ContractState, amount: u256) {
            let mut world = self.world_default();
            coins_impl::buy_coins(world, amount);
        }
    }

    #[generate_trait]
    impl BaseImpl of BaseTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"squares")
        }
    }
}
