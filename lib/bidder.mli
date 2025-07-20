open Strategy

(** A bidder has a name and a strategy for placing bids. *)
type bidder = {
  name : string;
  strategy : strategy_type;
}

val make : string -> strategy_type -> bidder
val bid : bidder -> float -> float list -> float
