open OUnit2
open Auction

let test_first_price _ =
  let bids = [("Alice", 10.0); ("Bob", 8.0); ("CJ", 12.0)] in
  let winner, amount = run_auction FirstPrice ~bids in
  assert_equal "CJ" winner;
  assert_equal 12.0 amount ~printer:string_of_float

let test_second_price _ =
  let bids = [("Alice", 10.0); ("Bob", 8.0); ("CJ", 12.0)] in
  let winner, amount = run_auction SecondPrice ~bids in
  assert_equal "CJ" winner;
  assert_equal 10.0 amount ~printer:string_of_float

let test_empty_bids _ =
  assert_raises (Failure "No valid bids") (fun () -> run_auction FirstPrice ~bids:[])

let suite =
  "Auction Tests" >::: [
    "First Price" >:: test_first_price;
    "Second Price" >:: test_second_price;
    "Empty Bids" >:: test_empty_bids;
  ]

let () = run_test_tt_main suite
