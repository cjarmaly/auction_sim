open Bidder

(** Supported auction formats. *)
type auction_type = FirstPrice | SecondPrice | English | Dutch

(** List of bids, pairing each participant with their bid amount. *)
type bids = (string * float) list

(** The winning bidder and the final price paid. *)
type winner = string * float

val run_auction :
  auction_type:auction_type ->
  bidders:bidder list ->
  private_values:(string * float) list ->
  winner
