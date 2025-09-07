# AuctionSim

A modular auction simulator written in OCaml. The project supports multiple 
auction formats and bidding strategies, and is designed to explore incentive 
compatibility and market design through simulation.

## Features

- First-price and second-price sealed-bid auctions
- Modular bidder design with customizable strategies
- Built using OCaml with Jane Street’s Core library
- Unit testing via OUnit2
- GitHub Actions CI for build and test verification

## Getting Started

### 1. Clone the repository

```bash
git clone git@github.com-cj:cjarmaly/auction_sim.git
cd auction_sim
```

### 2. Install dependencies

Requires `opam` and `dune`.

```bash
opam install dune core ounit2
```


## Build and Run

### Build the project

```bash
dune build
```

### Run the executable (basic)

```bash
dune exec bin/main.exe -- [OPTIONS]
```

## Command-Line Usage

You can configure the auction type, number of bidders, bidding strategy, and random seed via CLI options:

| Option         | Description                                                                 |
|--------------- |-----------------------------------------------------------------------------|
| `-a <type>`    | Auction type: `FirstPrice`, `SecondPrice`, `English`, or `Dutch`            |
| `-n <int>`     | Number of bidders (default: 5)                                               |
| `-s <strategy>`| Bidding strategy: `truthful`, `overbid`, `underbid`, `risk_averse`, `random`, `max_bidder` |
| `--seed <int>` | Set random seed for reproducibility                                          |

### Example CLI Commands

Run a first-price auction with 10 bidders, all using the overbid strategy:

```bash
dune exec bin/main.exe -- -a FirstPrice -n 10 -s overbid
```

Run an English auction with 4 bidders, random strategy, and a fixed seed:

```bash
dune exec bin/main.exe -- -a English -n 4 -s random --seed 42
```

### Available Auction Types

- `FirstPrice`: Highest bidder wins and pays their bid
- `SecondPrice`: Highest bidder wins, pays second-highest bid
- `English`: Ascending open auction (last remaining wins)
- `Dutch`: Descending price, first to accept wins

### Available Strategies

- `truthful`: Bidder bids their true value
- `overbid`: Bidder bids 120% of their value
- `underbid`: Bidder bids 80% of their value
- `risk_averse`: Bidder bids 60% of their value
- `random`: Bidder bids a random value between 50% and 100% of their value
- `max_bidder`: Bidder bids the highest public bid plus a small increment, or their value if no bids

### Output

The CLI prints:
- Auction type, number of bidders, and strategy
- Each bidder's private value
- Winner and winning bid
- All bids submitted

## Project Structure

```
auction_sim/
├── .github/workflows/ocaml.yml # GitHub Actions CI workflow 
├── bin/                        # Entry point 
├── lib/                        # Core modules: auction, bidder, strategy 
├── test/                       # Unit tests 
├── .gitattributes              # Git metadata settings 
├── .gitignore                  # Ignore build and editor artifacts 
├── dune-project                # Dune project definition 
└── README.md
```

## Example Usage

```ocaml
let bids = [ ("Alice", 10.0); ("Bob", 12.0); ("Carol", 11.5) ]
let (winner, amount) = Auction.run_auction FirstPrice ~bids
```

## Roadmap

- English and Dutch auction implementations
- Monte Carlo simulations with randomized bidders
- CSV or JSON output for analysis
- CLI interface for configurable runs

## License

MIT (to be added)

## Author

Christian Armaly — [cjarmaly](https://github.com/cjarmaly)
