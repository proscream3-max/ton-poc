// FIXED VERSION
// SC-001 fix: use mode 0 to send exactly ok.value, nothing more

contract PayoutsMaster {

    receive(ok: PayoutOk) {
        // ... signature checks ...

        emit(EventPayoutCompleted{
            address: ok.address,
            value: ok.value
        }.toCell());

        // ✅ FIXED: sends exactly ok.value, no extra gas forwarded
        send(SendParameters{
            value: ok.value,
            mode: 0,            // only explicit value, nothing on top
            bounce: false,      // payout already recorded, no need to bounce
            to: ok.address,
            body: "Payout completed".asComment()
        });
    }
}