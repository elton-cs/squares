use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
struct Bomba {
    #[key]
    id: bool,
    tick: u32,
    tick_limit: u32,
}

const BOMBA_ID: bool = true;
const TICK_LIMIT: u32 = 10; 

#[generate_trait]
impl BombaImpl of BombaTrait {
    fn new() -> Bomba {
        Bomba { id: BOMBA_ID, tick: 0, tick_limit: TICK_LIMIT }
    }

    fn increment_tick(ref self: Bomba) {
        self.tick += 1;
    }

    fn did_explode(ref self: Bomba) -> bool {
        self.tick == self.tick_limit
    }

    fn reset_tick(ref self: Bomba) {
        self.tick = 0
    }
}
