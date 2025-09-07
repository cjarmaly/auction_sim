
open Core
open Auction_sim.Bidder
open Auction_sim.Strategy
open Auction_sim.Auction


(** Command-line argument: auction type as string. *)
let auction_type_str : string ref = ref "FirstPrice"
(** Command-line argument: number of bidders. *)
let num_bidders : int ref = ref 5
(** Command-line argument: strategy as string. *)
let strategy_str : string ref = ref "truthful"
(** Command-line argument: random seed. *)
let seed : int option ref = ref None


(** Usage message for the CLI. *)
let usage_msg : string = "\nAuctionSim: OCaml Auction Simulator\n\nOptions:\n  -a <type>      Auction type (FirstPrice, SecondPrice, English, Dutch)\n  -n <int>       Number of bidders (default: 5)\n  -s <strategy>  Bidding strategy (truthful, overbid, underbid, risk_averse, random, max_bidder)\n  --seed <int>   Set random seed for reproducibility\n"


(** CLI argument specification. *)
let speclist : (string * Arg.spec * string) list = [
  ("-a", Arg.Set_string auction_type_str, "Auction type");
  ("-n", Arg.Set_int num_bidders, "Number of bidders");
  ("-s", Arg.Set_string strategy_str, "Bidding strategy");
  ("--seed", Arg.Int (fun i -> seed := Some i), "Random seed");
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


let bidder_pairs : (bidder * (string * float)) list = List.init !num_bidders ~f:gen_bidder
let bidders : bidder list = List.map bidder_pairs ~f:fst
let private_values : (string * float) list = List.map bidder_pairs ~f:snd


(** Main entry point: runs the auction and prints results. *)
let main () : unit =
  Printf.printf "\nAuction Type: %s\nBidders: %d\nStrategy: %s\n" !auction_type_str !num_bidders !strategy_str;
  Printf.printf "Private Values:\n";
  List.iter private_values ~f:(fun (name, v) -> Printf.printf "  %s: %.2f\n" name v);
  let (winner : string), (amount : float) =
    run_auction ~auction_type ~bidders ~private_values
  in
  Printf.printf "\nWinner: %s\nWinning Bid: %.2f\n" winner amount;
  Printf.printf "Bids:\n";
  List.iter bidders ~f:(fun b ->
    let v = List.Assoc.find_exn ~equal:String.equal private_values b.name in
    let bid_amt = bid b v [] in
    Printf.printf "  %s: %.2f\n" b.name bid_amt)

let () = main ()




  