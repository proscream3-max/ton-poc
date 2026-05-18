# TON Smart Contract Exploit PoC

## Overview

This proof-of-concept demonstrates a payout amplification issue in a TON smart contract implementation.

Under crafted conditions, an attacker can trigger reward calculations that exceed the intended payout amount.

---

## Vulnerability Summary

The contract uses `SendRemainingValue` (mode 64) together with an explicit
`ok.value` in the same `send()` call inside the `receive(ok: PayoutOk)` handler.

In TON, mode 64 means: "send the explicit value AND also forward
all remaining balance of the current inbound message."

Because the attacker controls the size of the inbound message value,
they can artificially inflate the actual payout far beyond
the amount authorized in the signed ticket.

The contract violates its own payout invariant:
  actual_transferred = ticket_value + attacker_controlled_inbound_value
instead of:
  actual_transferred = ticket_value

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

1. Attacker obtains a valid payout ticket for 1 TON.
2. Attacker sends a PayoutOk message with a large inbound value (e.g. 10 TON).
3. The contract executes send() with:
   - value: ok.value (1 TON from the ticket)
   - mode: SendRemainingValue (mode 64) — forwards remaining inbound balance on top
4. Recipient receives 1 TON + ~9.91 TON = ~10.91 TON total.
5. The attack succeeds in a single transaction — no repetition needed.

---

## Reproduction

Install dependencies:

```bash
npm install
Run exploit test:

```bash
npm test
Or run only the exploit PoC:

```bash
npx jest tests/exploit.spec.ts
```