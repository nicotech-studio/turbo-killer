import AppKit
import Foundation

actor MockTurboBoostController: TurboBoostControlling {
    var status: TurboBoostStatus = .enabled
    var readFailure = false
    var failAfterChangingState = false
    var reads = 0
    var writes = 0
    var heldRead: CheckedContinuation<Void, Never>?
    var holdNextRead = false

    func currentStatus() async throws -> TurboBoostStatus {
        reads += 1
        if holdNextRead {
            holdNextRead = false
            await withCheckedContinuation { heldRead = $0 }
        }
        if readFailure { throw TurboBoostControlError.commandFailed("read failed") }
        return status
    }

    func setTurboBoostEnabled(_ enabled: Bool) async throws {
        writes += 1
        status = enabled ? .enabled : .disabled
        if failAfterChangingState { throw TurboBoostControlError.approvalRequired }
    }

    func configure(status: TurboBoostStatus? = nil, readFailure: Bool = false, failAfterChangingState: Bool = false) {
        if let status { self.status = status }
        self.readFailure = readFailure
        self.failAfterChangingState = failAfterChangingState
    }
    func hold() { holdNextRead = true }
    func release() { heldRead?.resume(); heldRead = nil }
}

@main
struct StatusModelTests {
    @MainActor
    static func main() async throws {
        let mock = MockTurboBoostController()
        let model = TurboKillerModel(hardware: .intelMac, controller: mock, helperReady: true)
        precondition(model.turboBoostStatus == .unavailable)
        await model.refreshStatus()
        precondition(model.turboBoostStatus == .enabled)
        await model.toggleTurboBoost()
        precondition(model.turboBoostStatus == .disabled)
        await model.toggleTurboBoost()
        precondition(model.turboBoostStatus == .enabled)
        print("PASS: verified disable and restore update shared state")

        await mock.configure(readFailure: true)
        await model.refreshStatus()
        precondition(model.turboBoostStatus == .unavailable && model.statusReadError != nil)
        await mock.configure(status: .disabled)
        await model.refreshStatus()
        precondition(model.turboBoostStatus == .disabled && model.statusReadError == nil)
        print("PASS: read failure shows unknown and recovery clears the read error")

        await mock.configure(failAfterChangingState: true)
        await model.toggleTurboBoost()
        precondition(model.requiredAction == .approveKernelExtension)
        precondition(model.turboBoostStatus == .enabled && !model.isBusy)
        print("PASS: a partially failed operation re-reads state and retains approval guidance")

        await mock.configure()
        await mock.hold()
        let inFlight = Task { await model.refreshStatus() }
        while !(await mock.heldRead != nil) { await Task.yield() }
        let count = await mock.reads
        await model.refreshStatus()
        await model.toggleTurboBoost()
        let after = await mock.reads
        precondition(count == after)
        await mock.release()
        await inFlight.value
        precondition(!model.isRefreshing)
        print("PASS: overlapping reads and toggles cannot race the current read")

        let unsupportedMock = MockTurboBoostController()
        let unsupported = TurboKillerModel(hardware: .appleSilicon, controller: unsupportedMock)
        await unsupported.refreshStatus()
        await unsupported.prepareHelper()
        await unsupported.toggleTurboBoost()
        let unsupportedReads = await unsupportedMock.reads
        let unsupportedWrites = await unsupportedMock.writes
        precondition(unsupportedReads == 0 && unsupportedWrites == 0)
        precondition(!unsupported.helperReady && unsupported.requiredAction == nil)
        print("PASS: unsupported hardware neither reads nor writes nor requests helper approval")

        let monitoredMock = MockTurboBoostController()
        let monitored = TurboKillerModel(hardware: .intelMac, controller: monitoredMock)
        monitored.startMonitoring(pollInterval: .milliseconds(20))
        monitored.startMonitoring(pollInterval: .milliseconds(20))
        try await Task.sleep(for: .milliseconds(75))
        let monitoredReads = await monitoredMock.reads
        precondition(monitoredReads >= 2)
        precondition(!monitored.helperReady && monitored.requiredAction == nil)
        await monitoredMock.configure(status: .disabled)
        NSWorkspace.shared.notificationCenter.post(name: NSWorkspace.didWakeNotification, object: nil)
        try await Task.sleep(for: .milliseconds(25))
        precondition(monitored.turboBoostStatus == .disabled)
        monitored.stopMonitoring()
        let stoppedReads = await monitoredMock.reads
        try await Task.sleep(for: .milliseconds(50))
        let laterReads = await monitoredMock.reads
        precondition(stoppedReads == laterReads)
        print("PASS: launch, periodic and wake updates work without opening the popover; stop cancels monitoring")
        print("All status-model regression checks passed. No helper or kernel extension was installed or loaded.")
    }
}
