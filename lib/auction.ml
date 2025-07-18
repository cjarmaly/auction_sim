open Core

type auction_type = FirstPrice | SecondPrice | English | Dutch

let run_auction auction_type ~bids =
  match auction_type with
  | FirstPrice ->
      List.max_elt bids ~compare:(fun (_, b1) (_, b2) -> Float.compare b1 b2)
      |> Option.value_exn
  | SecondPrice ->
      let sorted = List.sort bids ~compare:(fun (_, b1) (_, b2) -> Float.compare b2 b1) in
      match sorted with
      | (winner, _) :: (_, second_bid) :: _ -> (winner, second_bid)
      | _ -> failwith "Not enough bidders for second-price auction"
  | English | Dutch ->
      failwith "Not implemented yet"
