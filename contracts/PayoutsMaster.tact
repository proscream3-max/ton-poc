// VULNERABLE VERSION — for bug bounty demonstration only
// SC-001: Payout amplification via SendRemainingValue + explicit value

contract PayoutsMaster {

    receive(ok: PayoutOk) {
        // ... signature checks ...

        emit(EventPayoutCompleted{
            address: ok.address,
            value: ok.value
        }.toCell());

        // ❌ VULNERABLE: sends ok.value + remaining inbound gas (mode 64)
        send(SendParameters{
            value: ok.value,
            mode: SendRemainingValue,   // mode 64 — adds remaining inbound balance on top
            to: ok.address,
            body: "Payout completed".asComment()
        });
    }
}