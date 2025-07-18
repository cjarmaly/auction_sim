type auction_type = FirstPrice | SecondPrice | English | Dutch

val run_auction :
  auction_type ->
  bids:(string * float) list ->
  winner:string * float
