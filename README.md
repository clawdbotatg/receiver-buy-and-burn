# 🔥 Receiver Buy & Burn

A permissionless smart contract that receives ETH, USDC, or CLAWD on Base and burns CLAWD to the dead address (`0x...dEaD`). ETH and USDC are swapped to CLAWD via Uniswap V3 first; CLAWD sent directly is burned as-is. Anyone can call `execute()` at any time — no owner, no admin keys, no rug risk.

## Contract Addresses

| Network | Address |
|---------|---------|
| Base | [`0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad`](https://basescan.org/address/0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad) ✅ Live |

> Same vanity address on every EVM chain — deployed via [Nick's CREATE2 factory](https://github.com/Arachnid/deterministic-deployment-proxy). Address reads **`0x0·C1a3D·B07`** = *clawd-bot*. Salt mined by clawdhead (16 threads, ~10 min).

**ENS Name:** [`pay.clawdbotatg.eth`](https://app.ens.domains/pay.clawdbotatg.eth) → resolves to `0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad`

## How It Works

1. Send USDC, ETH, or CLAWD to `0x0C1a3DB07304D2E4E551AB4A7b083382a33f25ad` (or `pay.clawdbotatg.eth`) on Base
2. Anyone calls `execute()`
3. All ETH is wrapped to WETH → swapped to CLAWD via Uniswap V3 (1% fee pool)
4. All USDC is multihop swapped: USDC → WETH (0.05% pool) → CLAWD (1% pool)
5. Any CLAWD held directly is sent straight to dead (no swap needed)
6. All CLAWD ends up at `0x000000000000000000000000000000000000dEaD` — burned forever

## Key Addresses (Base)

| Token/Contract | Address |
|----------------|---------|
| CLAWD | `0x9f86dB9fc6f7c9408e8Fda3Ff8ce4e78ac7a6b07` |
| USDC | `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913` |
| WETH | `0x4200000000000000000000000000000000000006` |
| Uniswap V3 Router (SwapRouter02) | `0x2626664c2603336E57B271c5C0b26F421741e481` |
| Dead Address | `0x000000000000000000000000000000000000dEaD` |

## Development

```bash
# Install dependencies
forge install

# Run tests (requires Base mainnet fork)
ALCHEMY_KEY=<key> forge test --fork-url https://base-mainnet.g.alchemy.com/v2/<key> -vv

# Deploy (via CREATE2 factory — same address on any chain)
forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast
```

## Audit

See [AUDIT-REPORT.md](./AUDIT-REPORT.md). 7 specialized audit agents reviewed the contract. Key known limitation: `amountOutMinimum: 0` means no slippage protection — acceptable for a burn-only contract (worst case: slightly fewer CLAWD burned).

## License

MIT
