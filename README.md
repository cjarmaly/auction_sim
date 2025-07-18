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

### Run the executable

```bash
dune exec bin/main.exe
```

### Run the test suite

```bash
dune runtest
```

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
