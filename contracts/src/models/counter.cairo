#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
struct Counter {
    #[key]
    id: felt252,
    count: u64,
}
