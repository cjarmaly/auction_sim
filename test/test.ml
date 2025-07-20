open OUnit2

let test_first_price _ =
  let bids = [("CJ", 3.0); ("Blake", 2.0)] in
  let winner, amount = Auction.run_auction FirstPrice ~bids in
  assert_equal (winner, amount) ("CJ", 3.0)


let suite =
  "Auction Tests" >::: [
    "test_first_price" >:: test_first_price;
  ]

let () = run_test_tt_main suite

