# Tokenized Fisheries Market Price Discovery

A decentralized system for fish market verification, price reporting, quality grading, auction management, and payment processing built on the Stacks blockchain using Clarity smart contracts.

## Overview

This project provides a comprehensive solution for modernizing fisheries markets through blockchain technology. It enables transparent price discovery, quality assurance, and secure transactions in the fish trading ecosystem.

## Features

### 🏪 Market Verification
- Register and verify fish markets
- License validation and compliance tracking
- Market status management (pending, verified, suspended)

### 💰 Price Reporting
- Real-time fish price reporting by verified markets
- Species-specific pricing (Salmon, Tuna, Cod, Mackerel)
- Historical price tracking and analytics
- Quality-grade based pricing

### 🎯 Quality Grading
- Certified grader system
- Standardized quality grades (A, B, C)
- Freshness scoring (1-10 scale)
- Size categorization and detailed notes

### 🔨 Auction Management
- Create fish auctions with duration limits
- Real-time bidding system
- Automatic auction ending
- Highest bidder tracking

### 💳 Payment Processing
- Secure escrow-based payments
- Multi-party transaction support
- Balance management and withdrawals
- Payment status tracking

## Smart Contracts

### 1. Market Verification Contract (\`market-verification.clar\`)
Manages the registration and verification of fish markets.

**Key Functions:**
- \`register-market\`: Register a new fish market
- \`verify-market\`: Verify a market (admin only)
- \`get-market\`: Retrieve market information
- \`is-market-verified\`: Check market verification status

### 2. Price Reporting Contract (\`price-reporting.clar\`)
Handles fish price reporting and tracking across markets.

**Key Functions:**
- \`report-price\`: Report fish prices with quality grades
- \`get-latest-price\`: Get current market price for a species
- \`get-price-report\`: Retrieve historical price reports

### 3. Quality Grading Contract (\`quality-grading.clar\`)
Manages fish quality assessments by certified graders.

**Key Functions:**
- \`certify-grader\`: Certify quality graders (admin only)
- \`grade-fish\`: Grade fish quality with detailed metrics
- \`get-fish-grade\`: Retrieve grading information

### 4. Auction Management Contract (\`auction-management.clar\`)
Facilitates fish auctions and bidding processes.

**Key Functions:**
- \`create-auction\`: Create new fish auctions
- \`place-bid\`: Place bids on active auctions
- \`end-auction\`: End auctions and determine winners

### 5. Payment Processing Contract (\`payment-processing.clar\`)
Handles secure payments and fund management.

**Key Functions:**
- \`deposit\`: Deposit funds to user balance
- \`create-payment\`: Create escrow payments
- \`process-payment\`: Complete payment transactions
- \`withdraw\`: Withdraw available funds

## Installation

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) for local development
- Node.js 16+ for running tests
- Stacks wallet for mainnet/testnet deployment

### Setup

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/your-org/fisheries-market.git
   cd fisheries-market
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

4. Deploy contracts (testnet):
   \`\`\`bash
   clarinet deployments apply -p deployments/testnet.yaml
   \`\`\`

## Usage Examples

### Register a Fish Market
\`\`\`clarity
(contract-call? .market-verification register-market
"Harbor Fish Market"
"Boston Harbor, MA"
"LIC-2024-001")
\`\`\`

### Report Fish Prices
\`\`\`clarity
(contract-call? .price-reporting report-price
u1          ;; market-id
u1          ;; species (salmon)
u2500       ;; price per kg in cents
u100        ;; quantity available
u1)         ;; quality grade
\`\`\`

### Create Fish Auction
\`\`\`clarity
(contract-call? .auction-management create-auction
u1          ;; fish species
u50         ;; quantity
u1          ;; quality grade
u2000       ;; starting price
u144        ;; duration (blocks)
u1)         ;; market id
\`\`\`

## Testing

The project includes comprehensive test suites using Vitest:

- **Market Verification Tests**: Registration, verification, and status checking
- **Price Reporting Tests**: Price reporting, retrieval, and validation
- **Auction Management Tests**: Auction creation, bidding, and completion
- **Quality Grading Tests**: Grader certification and fish grading
- **Payment Processing Tests**: Deposits, payments, and withdrawals

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Architecture

### Data Flow
1. **Market Registration**: Markets register and get verified by administrators
2. **Price Discovery**: Verified markets report real-time fish prices
3. **Quality Assessment**: Certified graders evaluate fish quality
4. **Auction Process**: Sellers create auctions, buyers place bids
5. **Payment Settlement**: Secure escrow-based payment processing

### Security Features
- Role-based access control
- Input validation and error handling
- Escrow-based payment system
- Market verification requirements
- Grader certification system

## Contributing

1. Fork the repository
2. Create a feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

- [ ] Mobile app integration
- [ ] IoT sensor integration for quality monitoring
- [ ] Multi-chain deployment support
- [ ] Advanced analytics dashboard
- [ ] Integration with existing fish market systems
- [ ] Regulatory compliance modules

## Support

For support and questions:
- Create an issue on GitHub
- Join our Discord community
- Email: support@fisheries-market.com

## Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Clarity language documentation and community
- Open source contributors and testers
  \`\`\`
  \`\`\`

Finally, let's create the PR details file:
