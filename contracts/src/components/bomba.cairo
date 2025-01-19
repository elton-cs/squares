#[starknet::component]
mod BombaComponent {
    use starknet::{get_caller_address};
    use squares::models::bomba::{BombaTrait, Bomba};
    use squares::store::{StoreTrait, Store};
    use dojo::world::WorldStorage;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    const BOMBA_RESOURCE_ID: bool = true;

    #[generate_trait]
    impl BaseImpl<T, +HasComponent<T>> of BaseTrait<T> {
        // only for dojo_init
        fn init_bomba(world: WorldStorage) {
            let mut store = StoreTrait::new(world);
            let mut bomba = BombaTrait::new();
            store.write_bomba(@bomba);
        }

        // player callable
        fn tick_bomba(world: WorldStorage) -> bool {
            let mut store = StoreTrait::new(world);
            let mut bomba = store.read_bomba(BOMBA_RESOURCE_ID);
            let did_bomba_explode = bomba.did_explode();
            if !did_bomba_explode {
                bomba.increment_tick();
            } else {
                bomba.reset_tick();
            }
            store.write_bomba(@bomba);

            did_bomba_explode
        }
    }
}

