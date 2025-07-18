let test_first_price _ =
  let bids = [ ("Blake", 10.0); ("CJ", 12.0); ("Seb", 11.5) ] in
  let winner, amount = Auction.run_auction FirstPrice ~bids in
  assert_equal winner "CJ";
  assert_equal amount 12.0
