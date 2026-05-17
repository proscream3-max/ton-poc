# TON Smart Contract Exploit PoC

## Overview

This proof-of-concept demonstrates a payout amplification issue in a TON smart contract implementation.

Under crafted conditions, an attacker can trigger reward calculations that exceed the intended payout amount.

---

## Vulnerability Summary

The contract logic does not properly validate payout state transitions during reward processing.

An attacker can repeatedly trigger payout calculations using crafted internal messages, resulting in amplified withdrawals.

---

## Impact

An attacker may receive significantly more funds than expected.

Example:

- Initial Deposit: 1 TON
- Expected Payout: 1 TON
- Actual Payout: 10.91 TON
- Attacker Profit: 9.91 TON

---

## Severity

High

Reasoning:

- direct fund extraction
- repeatable attack
- no privileged access required
- contract balance may be drained

---

## Attack Scenario

1. Attacker deploys crafted interaction flow
2. Reward logic is triggered multiple times
3. Contract recalculates payout incorrectly
4. Attacker receives amplified payout

---

## Reproduction

Install dependencies:

```bash
npm install