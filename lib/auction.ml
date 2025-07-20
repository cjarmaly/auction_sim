open Core
open Bidder

type auction_type = FirstPrice | SecondPrice | English | Dutch

type bids = (string * float) list
type winner = string * float

(* Runs the selected auction type and returns the winner and payment *)
let run_auction
    ~(auction_type : auction_type)
    ~(bidders : bidder list)
    ~(private_values : (string * float) list)
    : winner =
  let lookup_value name =
    List.Assoc.find ~equal:String.equal private_values name
  in

  let bids =
    List.filter_map bidders ~f:(fun b ->
      Option.map (lookup_value b.name) ~f:(fun v ->
        let amount = Bidder.bid b v [] in
        (b.name, amount)))
  in

  let sorted_bids =
    List.sort bids ~compare:(fun (_, x) (_, y) -> Float.compare y x)
  in

  match auction_type, sorted_bids with
  | _, [] -> failwith "No valid bids"

  | FirstPrice, (winner, amount) :: _ ->
      (winner, amount)

  | SecondPrice, (winner, _) :: (_, second_price) :: _ ->
      (winner, second_price)

  | SecondPrice, _ ->
      failwith "Not enough bids for second-price auction"

  | English, _ | Dutch, _ ->
      failwith "Not implemented yet"


