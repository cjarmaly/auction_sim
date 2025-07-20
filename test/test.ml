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

let suite =
  "Auction Tests" >::: [
    "First Price Auction" >:: test_first_price;
    "Second Price Auction" >:: test_second_price;
    "Empty Bids" >:: test_empty_bids;
  ]

let () = run_test_tt_main suite
