open Strategy


(** A bidder has a name and a bidding strategy. *)
type bidder = {
  name : string;
  strategy : strategy_type;
}

(** [make name strategy] constructs a new bidder with a name and bidding strategy. *)
let make (name : string) (strategy : strategy_type) : bidder =
  { name; strategy }

(** [bid b private_value public_bids] computes this bidder’s bid based on their private value and others’ bids. *)
let bid (b : bidder) (private_value : float) (public_bids : float list) : float =
  b.strategy private_value public_bids
