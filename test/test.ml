let test_first_price _ =
  let bids = [ ("Alice", 10.0); ("Bob", 12.0); ("Carol", 11.5) ] in
  let winner, amount = Auction.run_auction FirstPrice ~bids in
    assert_equal winner "Bob";
    assert_equal amount 12.0
