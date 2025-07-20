type bids = (string * float) list
type winner = string * float

type auction_type =
  | FirstPrice
  | SecondPrice
  | English
  | Dutch

val run_auction : auction_type -> bids:bids -> winner
