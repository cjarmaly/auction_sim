open Core


(** A bidding strategy is a function: private_value -> public_bids -> bid_amount *)
type strategy_type = float -> float list -> float

(* Always bids the true private value. *)
let truthful : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value

(* Inflates the bid by 20% to gain advantage in first-price auctions. *)
let overbid : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value *. 1.2

(* Bids conservatively: 80% of private value. *)
let underbid : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value *. 0.8

(* Risk-averse: bids 60% of private value. *)
let risk_averse : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value *. 0.6

(* Random: bids a random fraction (50%-100%) of private value. *)
let random_strategy : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    let fraction : float = 0.5 +. (Random.float 0.5) in
    private_value *. fraction

(* Max-bidder: bids the highest public bid plus a small increment, or private value if no bids. *)
let max_bidder : strategy_type =
  fun (private_value : float) (bids : float list) : float ->
    match bids with
    | [] -> private_value
    | _ ->
        let max_bid : float = List.fold_left ~init:0.0 ~f:Float.max bids in
        Float.min (max_bid +. 1.0) private_value
