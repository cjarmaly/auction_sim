open Core
open Auction_sim.Bidder
open Auction_sim.Strategy
open Auction_sim.Auction


(* Set default auction type and size *)
let auction_type_str = ref "FirstPrice"
let num_bidders = ref 5

(* Establish command line spec list *)
let speclist = [
  ("-a", Arg.Set_string auction_type_str, "Auction type");
  ("-n", Arg.Set_int num_bidders, "Number of bidders");
]

(* Parse command line arguments, printing usage_msg if failed *)
let usage_msg = "Usage: main.exe -a FirstPrice -n 5"
let () = Arg.parse speclist (fun _ -> ()) usage_msg


(* Translate auction_type_str into auction_type *)
let auction_type =
  match String.lowercase !auction_type_str with
  | "firstprice" -> FirstPrice
  | "secondprice" -> SecondPrice
  | "english" -> English
  | "dutch" -> Dutch
  | _ -> failwith "Unknown auction type"

(* Generate bidders and private values *)
let gen_bidder i =
  let name = Printf.sprintf "Bidder%d" i in
  let private_val = Random.float 100.0 in
  (make name truthful, (name, private_val))

let bidder_pairs = List.init !num_bidders ~f:gen_bidder
let bidders, private_values = List.unzip bidder_pairs

(* Execute the auction *)
let main () =
  let winner, amount =
    run_auction ~auction_type ~bidders ~private_values
  in
  Printf.printf "Winner: %s\nWinning Bid: %.2f\n" winner amount


let () = 
  print_endline "Auction Simulator: WIP"; 
  main ()




  