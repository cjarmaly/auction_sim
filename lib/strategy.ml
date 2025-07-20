type strategy_type = float -> float list -> float

(* Always bids the true private value *)
let truthful : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value

(* Inflates the bid by 20% to gain advantage in first-price auctions *)
let overbid : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value *. 1.2

(* Bids conservatively: 80% of private value *)
let underbid : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value *. 0.8
