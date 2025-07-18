type auction_type = FirstPrice | SecondPrice | English | Dutch
type winner = string * float
type bids = (string * float) list

val run_auction : auction_type -> bids -> winner
