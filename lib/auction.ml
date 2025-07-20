open Core

type auction_type = FirstPrice | SecondPrice | English | Dutch

type bids = (string * float) list
type winner = string * float

(* Runs the selected auction type and returns the winner and payment *)
let run_auction (auction_type : auction_type) ~(bids : bids) : winner =
  let sorted_bids =
    List.sort bids ~compare:(fun (_, b1) (_, b2) -> Float.compare b2 b1)
  in
  match auction_type, sorted_bids with
  | (_, []) -> failwith "No valid bids"
  | (FirstPrice, (w, a) :: _) -> (w, a)
  | (SecondPrice, (w, _) :: (_, second) :: _) -> (w, second)
  | (SecondPrice, [_]) -> failwith "Not enough bidders for second-price auction"
  | (_, _) -> failwith "Not implemented yet"

