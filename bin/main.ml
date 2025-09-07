
open Core
open Auction_sim.Bidder
open Auction_sim.Strategy
open Auction_sim.Auction


(** Command-line argument: auction type as string. *)
let auction_type_str : string ref = ref "FirstPrice"
(* Command-line argument: number of bidders. *)
let num_bidders : int ref = ref 5
(* Command-line argument: strategy as string. *)
let strategy_str : string ref = ref "truthful"
(* Command-line argument: random seed. *)
let seed : int option ref = ref None
(* Command-line argument: batch mode (number of simulations). *)
let batch : int ref = ref 0
(* Command-line argument: CSV output file. *)
let csv_file : string option ref = ref None


(** Usage message for the CLI. *)
let usage_msg : string = "\nAuctionSim: OCaml Auction Simulator\n\nOptions:\n  -a <type>      Auction type (FirstPrice, SecondPrice, English, Dutch)\n  -n <int>       Number of bidders (default: 5)\n  -s <strategy>  Bidding strategy (truthful, overbid, underbid, risk_averse, random, max_bidder)\n  --seed <int>   Set random seed for reproducibility\n  --batch <N>    Run N simulations and print summary statistics\n  --csv <file>   Write batch results to CSV file\n"


(** CLI argument specification. *)
let speclist : (string * Arg.spec * string) list = [
  ("-a", Arg.Set_string auction_type_str, "Auction type");
  ("-n", Arg.Set_int num_bidders, "Number of bidders");
  ("-s", Arg.Set_string strategy_str, "Bidding strategy");
  ("--seed", Arg.Int (fun i -> seed := Some i), "Random seed");
  ("--batch", Arg.Set_int batch, "Number of simulations to run");
  ("--csv", Arg.String (fun s -> csv_file := Some s), "CSV output file");
]

let () = Arg.parse speclist (fun _ -> ()) usage_msg


(** Parse the auction type from string. *)
let auction_type : Auction_sim.Auction.auction_type =
  match String.lowercase !auction_type_str with
  | "firstprice" -> FirstPrice
  | "secondprice" -> SecondPrice
  | "english" -> English
  | "dutch" -> Dutch
  | _ -> failwith "Unknown auction type"


(** Parse the strategy from string. *)
let strategy_of_string (s : string) : strategy_type =
  match String.lowercase s with
  | "truthful" -> truthful
  | "overbid" -> overbid
  | "underbid" -> underbid
  | "risk_averse" | "riskaverse" -> risk_averse
  | "random" -> random_strategy
  | "max_bidder" | "maxbidder" -> max_bidder
  | _ -> failwith "Unknown strategy"

let () =
  (match !seed with
  | Some i -> Random.init i
  | None -> Random.self_init ())


(** Generate a bidder and their private value. *)
let gen_bidder (i : int) : bidder * (string * float) =
  let name : string = Printf.sprintf "Bidder%d" i in
  let private_val : float = Random.float 100.0 in
  (make name (strategy_of_string !strategy_str), (name, private_val))



let run_once () : (string * float * (string * float) list * (string * float) list) =
  let bidder_pairs = List.init !num_bidders ~f:gen_bidder in
  let bidders = List.map bidder_pairs ~f:fst in
  let private_values = List.map bidder_pairs ~f:snd in
  let winner, amount = run_auction ~auction_type ~bidders ~private_values in
  let bids = List.map bidders ~f:(fun b ->
    let v = List.Assoc.find_exn ~equal:String.equal private_values b.name in
    (b.name, bid b v [])) in
  (winner, amount, private_values, bids)


(** Main entry point: runs the auction and prints results. *)
let write_csv_header oc num_bidders =
  Out_channel.output_string oc "trial,winner,amount";
  for i = 0 to num_bidders - 1 do
    Printf.fprintf oc ",bidder%d_value,bidder%d_bid" i i
  done;
  Out_channel.output_string oc "\n"

let write_csv_row oc trial (winner, amount, private_values, bids) =
  Printf.fprintf oc "%d,%s,%.2f" trial winner amount;
  List.iter private_values ~f:(fun (_, v) -> Printf.fprintf oc ",%.2f" v);
  List.iter bids ~f:(fun (_, b) -> Printf.fprintf oc ",%.2f" b);
  Out_channel.output_string oc "\n"

let main () : unit =
  if !batch > 0 then begin
    let results = List.init !batch ~f:(fun _ -> run_once ()) in
    let winning_bids = List.map results ~f:(fun (_, amt, _, _) -> amt) in
    let avg_amount = List.fold_left winning_bids ~init:0.0 ~f:( +. ) /. float_of_int !batch in
    let min_amount = List.fold_left winning_bids ~init:Float.infinity ~f:Float.min in
    let max_amount = List.fold_left winning_bids ~init:Float.neg_infinity ~f:Float.max in
    let stddev =
      let mean = avg_amount in
      let sumsq = List.fold_left winning_bids ~init:0.0 ~f:(fun acc x -> acc +. (x -. mean) ** 2.) in
      sqrt (sumsq /. float_of_int !batch)
    in
    let all_bids = List.concat_map results ~f:(fun (_, _, _, bids) -> List.map bids ~f:snd) in
    let bid_mean = List.fold_left all_bids ~init:0.0 ~f:( +. ) /. float_of_int (List.length all_bids) in
    let bid_var =
      let sumsq = List.fold_left all_bids ~init:0.0 ~f:(fun acc x -> acc +. (x -. bid_mean) ** 2.) in
      sumsq /. float_of_int (List.length all_bids)
    in
    let win_counts =
      List.fold_left results ~init:String.Map.empty ~f:(fun acc (winner, _, _, _) ->
        Map.update acc winner ~f:(function None -> 1 | Some n -> n + 1))
    in
    Printf.printf "\nBatch mode: %d simulations\n" !batch;
    Printf.printf "Average winning bid: %.2f\n" avg_amount;
    Printf.printf "Min winning bid: %.2f\n" min_amount;
    Printf.printf "Max winning bid: %.2f\n" max_amount;
    Printf.printf "Stddev winning bid: %.2f\n" stddev;
    Printf.printf "Bid variance: %.2f\n" bid_var;
    Printf.printf "Win counts:\n";
    Map.iteri win_counts ~f:(fun ~key ~data -> Printf.printf "  %s: %d\n" key data);
    (match !csv_file with
    | Some fname ->
        let oc = Out_channel.create fname in
        write_csv_header oc !num_bidders;
        List.iteri results ~f:(fun i row -> write_csv_row oc i row);
        Out_channel.close oc;
        Printf.printf "Results written to %s\n" fname
    | None -> ())
  end else begin
    let winner, amount, private_values, bids = run_once () in
    Printf.printf "\nAuction Type: %s\nBidders: %d\nStrategy: %s\n" !auction_type_str !num_bidders !strategy_str;
    Printf.printf "Private Values:\n";
    List.iter private_values ~f:(fun (name, v) -> Printf.printf "  %s: %.2f\n" name v);
    Printf.printf "\nWinner: %s\nWinning Bid: %.2f\n" winner amount;
    Printf.printf "Bids:\n";
    List.iter bids ~f:(fun (name, bid_amt) -> Printf.printf "  %s: %.2f\n" name bid_amt)
  end

let () = main ()




  