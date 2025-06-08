;; Fish Market Verification Contract
;; Validates and manages fish market registrations

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_MARKET_EXISTS (err u101))
(define-constant ERR_MARKET_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Market status constants
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_SUSPENDED u2)

;; Data structures
(define-map markets
  { market-id: uint }
  {
    owner: principal,
    name: (string-ascii 50),
    location: (string-ascii 100),
    status: uint,
    verification-date: uint,
    license-number: (string-ascii 20)
  }
)

(define-map market-counter principal uint)
(define-data-var next-market-id uint u1)

;; Register a new fish market
(define-public (register-market (name (string-ascii 50)) (location (string-ascii 100)) (license-number (string-ascii 20)))
  (let ((market-id (var-get next-market-id)))
    (asserts! (is-none (map-get? markets { market-id: market-id })) ERR_MARKET_EXISTS)
    (map-set markets
      { market-id: market-id }
      {
        owner: tx-sender,
        name: name,
        location: location,
        status: STATUS_PENDING,
        verification-date: block-height,
        license-number: license-number
      }
    )
    (var-set next-market-id (+ market-id u1))
    (ok market-id)
  )
)

;; Verify a market (admin only)
(define-public (verify-market (market-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? markets { market-id: market-id })
      market-data
      (begin
        (map-set markets
          { market-id: market-id }
          (merge market-data { status: STATUS_VERIFIED, verification-date: block-height })
        )
        (ok true)
      )
      ERR_MARKET_NOT_FOUND
    )
  )
)

;; Get market information
(define-read-only (get-market (market-id uint))
  (map-get? markets { market-id: market-id })
)

;; Check if market is verified
(define-read-only (is-market-verified (market-id uint))
  (match (map-get? markets { market-id: market-id })
    market-data (is-eq (get status market-data) STATUS_VERIFIED)
    false
  )
)
