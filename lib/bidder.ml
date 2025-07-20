open Strategy

type bidder = {
  name : string;
  strategy : strategy_type;
}

(* Constructs a new bidder with a name and bidding strategy *)
let make (name : string) (strategy : strategy_type) : bidder =
  { name; strategy }


(* Computes this bidder’s bid based on their private value and others’ bids *)
let bid (b : bidder) (private_value : float) (public_bids : float list) : float =
  b.strategy private_value public_bids
