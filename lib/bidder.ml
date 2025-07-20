open Strategy

type bidder = {
  name : string;
  strategy : strategy_type;
}

let make (name : string) (strategy : strategy_type) : bidder =
  { name; strategy }

let bid (b : bidder) (private_value : float) (public_bids : float list) : float =
  b.strategy private_value public_bids
