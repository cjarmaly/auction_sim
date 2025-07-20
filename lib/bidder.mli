open Strategy

type bidder = {
  name : string;
  strategy : strategy_type;
}

val make : string -> strategy_type -> bidder
val bid : bidder -> float -> float list -> float

