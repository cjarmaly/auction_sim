type strategy_type = float -> float list -> float

let truthful : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value

let overbid : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    private_value *. 1.2

let underbid : strategy_type =
  fun (private_value : float) (_bids : float list) : float ->
    max 0.0 (private_value *. 0.8)
