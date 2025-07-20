(** Strategy functions determine how bidders behave based on their private value and others' bids. *)

type strategy_type = float -> float list -> float

val truthful : strategy_type
val overbid : strategy_type
val underbid : strategy_type
