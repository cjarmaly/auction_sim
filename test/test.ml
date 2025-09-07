open OUnit2
open Auction_sim.Bidder
open Auction_sim.Strategy
open Auction_sim.Auction



let test_first_price _ =
  let bidders = [
    make "Alice" truthful;
    make "Bob" truthful;
    make "CJ" truthful
  ] in
  let private_values = [
    ("Alice", 10.0);
    ("Bob", 8.0);
    ("CJ", 12.0)
  ] in
  let winner, amount =
    run_auction
      ~auction_type:FirstPrice
      ~bidders
      ~private_values
  in
  assert_equal "CJ" winner;
  assert_equal 12.0 amount ~printer:string_of_float

let test_second_price _ =
  let bidders = [
    make "Alice" truthful;
    make "Bob" truthful;
    make "CJ" truthful
  ] in
  let private_values = [
    ("Alice", 10.0);
    ("Bob", 8.0);
    ("CJ", 12.0)
  ] in
  let winner, amount =
    run_auction
      ~auction_type:SecondPrice
      ~bidders
      ~private_values
  in
  assert_equal "CJ" winner;
  assert_equal 10.0 amount ~printer:string_of_float

let test_empty_bids _ =
  let bidders = [] in
  let private_values = [] in
  assert_raises (Failure "No valid bids") (fun () ->
    run_auction
      ~auction_type:FirstPrice
      ~bidders
      ~private_values
  )


let test_english _ =
  let bidders = [
    make "Alice" truthful;
    make "Bob" truthful;
    make "CJ" truthful
  ] in
  let private_values = [
    ("Alice", 10.0);
    ("Bob", 8.0);
    ("CJ", 12.0)
  ] in
  let winner, amount =
    run_auction
      ~auction_type:English
      ~bidders
      ~private_values
  in
  assert_equal "CJ" winner;
  assert_equal 10.01 amount ~printer:string_of_float

let test_dutch _ =
  let bidders = [
    make "Alice" truthful;
    make "Bob" truthful;
    make "CJ" truthful
  ] in
  let private_values = [
    ("Alice", 10.0);
    ("Bob", 8.0);
    ("CJ", 12.0)
  ] in
  let winner, amount =
    run_auction
      ~auction_type:Dutch
      ~bidders
      ~private_values
  in
  assert_equal "CJ" winner;
  assert_equal 12.0 amount ~printer:string_of_float

let test_overbid _ =
  let b = make "Over" overbid in
  let bid = bid b 10.0 [] in
  assert_equal 12.0 bid ~printer:string_of_float

let test_underbid _ =
  let b = make "Under" underbid in
  let bid = bid b 10.0 [] in
  assert_equal 8.0 bid ~printer:string_of_float

let test_risk_averse _ =
  let b = make "RiskAverse" risk_averse in
  let bid = bid b 10.0 [] in
  assert_equal 6.0 bid ~printer:string_of_float

let test_random_strategy _ =
  let b = make "Random" random_strategy in
  let bid = bid b 10.0 [] in
  assert_bool "Random bid in range" (bid >= 5.0 && bid <= 10.0)

let test_max_bidder _ =
  let b = make "MaxBidder" max_bidder in
  let bid1 = bid b 10.0 [] in
  let bid2 = bid b 10.0 [7.0; 8.0; 9.0] in
  assert_equal 10.0 bid1 ~printer:string_of_float;
  assert_equal 10.0 bid2 ~printer:string_of_float

let suite =
  "Auction Tests" >::: [
    "First Price Auction" >:: test_first_price;
    "Second Price Auction" >:: test_second_price;
    "English Auction" >:: test_english;
    "Dutch Auction" >:: test_dutch;
    "Overbid Strategy" >:: test_overbid;
    "Underbid Strategy" >:: test_underbid;
    "Risk Averse Strategy" >:: test_risk_averse;
    "Random Strategy" >:: test_random_strategy;
    "Max Bidder Strategy" >:: test_max_bidder;
    "Empty Bids" >:: test_empty_bids;
  ]

let () = run_test_tt_main suite
