# 🔥 Receiver Buy & Burn

A permissionless smart contract that receives USDC, ETH, or CLAWD, swaps everything to CLAWD via Uniswap V3 on Base, and burns it to the dead address (`0x...dEaD`). Anyone can call `swapAndBurn()` at any time — no owner, no admin keys, no rug risk.

## Contract Addresses

| Network | Address |
|---------|---------|
| Base    | [`0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad`](https://basescan.org/address/0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad) _(not yet deployed)_ |
| Ethereum Mainnet | [`0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad`](https://etherscan.io/address/0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad) _(not yet deployed)_ |

> Same address on every chain — deployed via [Nick's CREATE2 factory](https://github.com/Arachnid/deterministic-deployment-proxy) with a mined salt. Address reads **`0x0-C1a3D-B07`** = *clawd-bot*. Mined by clawdhead (16 threads, ~10 min).

**ENS Name:** TBD (`burn.clawd.eth` or similar)

## Key Addresses (Base)

| Token/Contract | Address |
|----------------|---------|
| CLAWD | `0x9f86dB9fc6f7c9408e8Fda3Ff8ce4e78ac7a6b07` |
| USDC | `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913` |
| WETH | `0x4200000000000000000000000000000000000006` |
| Uniswap V3 Router | `0x2626664c2603336E57B271c5C0b26F421741e481` |
| Dead Address | `0x000000000000000000000000000000000000dEaD` |

## How It Works

1. Send USDC, ETH, or CLAWD to the contract address
2. Anyone calls `execute()`
3. ETH → WETH → CLAWD (1% pool), USDC → WETH → CLAWD (multihop via 0.05% + 1% pools)
4. All CLAWD sent to `0x...dEaD` (burned forever)

## Development

```bash
# Install dependencies
forge install

# Run tests (requires Base mainnet fork)
forge test --fork-url https://base-mainnet.g.alchemy.com/v2/<YOUR_KEY> -vv

# Deploy
forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast
```

## Audit

See [AUDIT-REPORT.md](./AUDIT-REPORT.md) for the full security audit.

## License

MIT
