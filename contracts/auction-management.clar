;; Auction Management Contract
;; Manages fish auctions and bidding

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_AUCTION_NOT_FOUND (err u401))
(define-constant ERR_AUCTION_ENDED (err u402))
(define-constant ERR_BID_TOO_LOW (err u403))
(define-constant ERR_AUCTION_ACTIVE (err u404))
(define-constant ERR_INSUFFICIENT_FUNDS (err u405))

;; Auction status
(define-constant STATUS_ACTIVE u1)
(define-constant STATUS_ENDED u2)
(define-constant STATUS_CANCELLED u3)

;; Auction data
(define-map auctions
  { auction-id: uint }
  {
    seller: principal,
    fish-species: uint,
    quantity: uint,
    quality-grade: uint,
    starting-price: uint,
    current-bid: uint,
    highest-bidder: (optional principal),
    end-block: uint,
    status: uint,
    market-id: uint
  }
)

(define-map auction-bids
  { auction-id: uint, bidder: principal }
  { bid-amount: uint, bid-block: uint }
)

(define-data-var next-auction-id uint u1)

;; Create auction
(define-public (create-auction (fish-species uint) (quantity uint) (quality-grade uint) (starting-price uint) (duration uint) (market-id uint))
  (let ((auction-id (var-get next-auction-id)))
    (map-set auctions
      { auction-id: auction-id }
      {
        seller: tx-sender,
        fish-species: fish-species,
        quantity: quantity,
        quality-grade: quality-grade,
        starting-price: starting-price,
        current-bid: starting-price,
        highest-bidder: none,
        end-block: (+ block-height duration),
        status: STATUS_ACTIVE,
        market-id: market-id
      }
    )
    (var-set next-auction-id (+ auction-id u1))
    (ok auction-id)
  )
)

;; Place bid
(define-public (place-bid (auction-id uint) (bid-amount uint))
  (match (map-get? auctions { auction-id: auction-id })
    auction-data
    (begin
      (asserts! (is-eq (get status auction-data) STATUS_ACTIVE) ERR_AUCTION_ENDED)
      (asserts! (< block-height (get end-block auction-data)) ERR_AUCTION_ENDED)
      (asserts! (> bid-amount (get current-bid auction-data)) ERR_BID_TOO_LOW)

      ;; Record bid
      (map-set auction-bids
        { auction-id: auction-id, bidder: tx-sender }
        { bid-amount: bid-amount, bid-block: block-height }
      )

      ;; Update auction
      (map-set auctions
        { auction-id: auction-id }
        (merge auction-data {
          current-bid: bid-amount,
          highest-bidder: (some tx-sender)
        })
      )

      (ok true)
    )
    ERR_AUCTION_NOT_FOUND
  )
)

;; End auction
(define-public (end-auction (auction-id uint))
  (match (map-get? auctions { auction-id: auction-id })
    auction-data
    (begin
      (asserts! (or (is-eq tx-sender (get seller auction-data)) (>= block-height (get end-block auction-data))) ERR_UNAUTHORIZED)
      (asserts! (is-eq (get status auction-data) STATUS_ACTIVE) ERR_AUCTION_ENDED)

      (map-set auctions
        { auction-id: auction-id }
        (merge auction-data { status: STATUS_ENDED })
      )

      (ok (get highest-bidder auction-data))
    )
    ERR_AUCTION_NOT_FOUND
  )
)

;; Get auction details
(define-read-only (get-auction (auction-id uint))
  (map-get? auctions { auction-id: auction-id })
)

;; Get bid details
(define-read-only (get-bid (auction-id uint) (bidder principal))
  (map-get? auction-bids { auction-id: auction-id, bidder: bidder })
)
