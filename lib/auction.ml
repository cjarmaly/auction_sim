open Core
open Bidder


(** Auction types supported by the simulator. *)
type auction_type = FirstPrice | SecondPrice | English | Dutch

(** A list of (bidder name, bid amount) pairs. *)
type bids = (string * float) list

(** The winner: (bidder name, amount paid). *)
type winner = string * float

(*
  [run_auction ~auction_type ~bidders ~private_values] runs the specified auction and returns the winner and payment.
  @param auction_type The auction format to use.
  @param bidders The list of participating bidders.
  @param private_values The private value for each bidder (name, value).
  @return (winner_name, amount_paid)
*)
let run_auction
    ~(auction_type : auction_type)
    ~(bidders : bidder list)
    ~(private_values : (string * float) list)
    : winner =
  (* Helper to look up a bidder's private value by name. *)
  let lookup_value : string -> float option =
    fun (name : string) ->
      List.Assoc.find ~equal:String.equal private_values name
  in

  (* Compute all bids for the auction. *)
  let bids : bids =
    List.filter_map bidders ~f:(fun (b : bidder) ->
      Option.map (lookup_value b.name) ~f:(fun (v : float) ->
        let amount : float = Bidder.bid b v [] in
        (b.name, amount)))
  in

  (* Sort bids in descending order. *)
  let sorted_bids : bids =
    List.sort bids ~compare:(fun ((_, x) : string * float) ((_, y) : string * float) -> Float.compare y x)
  in

  match auction_type, sorted_bids with
  | _, [] -> failwith "No valid bids"

  | FirstPrice, (winner, amount) :: _ ->
      (winner, amount)

  | SecondPrice, (winner, _) :: (_, second_price) :: _ ->
      (winner, second_price)

  | SecondPrice, _ ->
      failwith "Not enough bids for second-price auction"

  | English, _ ->
      (* English auction: ascending price, last remaining wins at price just above second-highest value *)
      let rec simulate (price : float) (active_bidders : string list) : winner =
        match active_bidders with
        | [last_name] ->
            let last_value : float = List.Assoc.find_exn ~equal:String.equal private_values last_name in
            let second_highest : float option =
              List.filter private_values ~f:(fun (name, _) -> String.(name <> last_name))
              |> List.map ~f:snd
              |> List.max_elt ~compare:Float.compare
            in
            let pay : float =
              match second_highest with
              | Some v -> Float.min (v +. 0.01) last_value
              | None -> last_value
            in
            (last_name, pay)
        | [] -> failwith "No bidders left in English auction"
        | _ ->
            let next_price : float = price +. 0.01 in
            let still_in : string list =
              List.filter active_bidders ~f:(fun (name : string) ->
                let v : float = List.Assoc.find_exn ~equal:String.equal private_values name in
                Float.(v >= next_price))
            in
            simulate next_price still_in
      in
      let all_names : string list = List.map bidders ~f:(fun (b : bidder) -> b.name) in
      simulate 0.0 all_names

  | Dutch, _ ->
      (* Dutch auction: descending price, first bidder whose value >= price wins *)
      let all_names : string list = List.map bidders ~f:(fun (b : bidder) -> b.name) in
      let max_value : float =
        List.map private_values ~f:snd |> List.max_elt ~compare:Float.compare |> Option.value ~default:0.0
      in
      let rec simulate (price : float) : winner =
        match List.find all_names ~f:(fun (name : string) ->
          let v : float = List.Assoc.find_exn ~equal:String.equal private_values name in
          Float.(v >= price)) with
        | Some winner_name -> (winner_name, price)
        | None ->
            let next_price : float = price -. 0.01 in
            if Float.(next_price < (List.map private_values ~f:snd |> List.min_elt ~compare:Float.compare |> Option.value ~default:0.0))
            then failwith "No bidder accepted the price in Dutch auction"
            else simulate next_price
      in
      simulate max_value


