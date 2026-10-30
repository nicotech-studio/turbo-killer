import AppKit
import Charts
import SwiftUI

/// Create this window only after an explicit click. A SwiftUI Window scene can
/// participate in launch restoration, which would disturb a menu-bar-only app
/// on older supported macOS releases.
@MainActor
final class FrequencyHistoryWindowController: NSWindowController, NSWindowDelegate {
    static let shared = FrequencyHistoryWindowController()
    private var monitor: CPUFrequencyMonitor?

    private init() { super.init(window: nil) }
    required init?(coder: NSCoder) { nil }

    func show(monitor: CPUFrequencyMonitor) {
        if window == nil {
            let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 680, height: 380),
                                  styleMask: [.titled, .closable, .miniaturizable, .resizable],
                                  backing: .buffered, defer: false)
            window.title = String(localized: "Frequency Monitor")
            window.contentViewController = NSHostingController(rootView: FrequencyHistoryView(monitor: monitor))
            window.minSize = NSSize(width: 540, height: 365)
            window.isReleasedWhenClosed = false
            window.delegate = self
            window.center()
            self.window = window
        }
        self.monitor = monitor
        monitor.setHistoryVisible(true)
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification) {
        monitor?.setHistoryVisible(false)
        monitor = nil
        // Release the host, its TimelineView and appearance observers on close.
        window?.contentViewController = nil
        window = nil
    }
}

/// Frequency and its history link share the status section. Long translations
/// can use a third row instead of truncating the value or the action.
struct CPUFrequencySummary: View {
    @ObservedObject var monitor: CPUFrequencyMonitor

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                value.fixedSize()
                Spacer(minLength: 0)
                historyButton.fixedSize()
            }
            VStack(alignment: .leading, spacing: 5) {
                value
                historyButton
            }
        }
    }

    private var value: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("CPU Frequency")
            if let reading = monitor.current {
                Text(reading.hertz / 1_000_000_000, format: .number.precision(.fractionLength(2)))
            } else { Text("—") }
            Text("GHz").font(.system(size: 11))
        }
        .font(.system(size: 12))
        .monospacedDigit()
        .foregroundStyle(.secondary)
        .help(frequencySamplingDescription(monitor))
    }

    private var historyButton: some View {
        Button {
            FrequencyHistoryWindowController.shared.show(monitor: monitor)
        } label: {
            HStack(spacing: 3) {
                Text("Frequency History")
                Image(systemName: "chevron.forward").font(.system(size: 9, weight: .medium))
            }
        }
        .buttonStyle(.plain)
        .font(.system(size: 11))
        .foregroundStyle(.tint)
        .help(Text("View Frequency History"))
    }
}

@MainActor
private func frequencySamplingDescription(_ monitor: CPUFrequencyMonitor) -> Text {
    if !monitor.helperAvailable {
        Text("Frequency monitoring requires the background helper.")
    } else if monitor.samplingFailed {
        Text("Frequency unavailable. Retrying automatically…")
    } else if monitor.current == nil {
        Text(monitor.isSampling ? "Sampling CPU frequency…" : "Frequency monitoring is paused.")
    } else {
        Text("Recent sample average · every \(monitor.interval) seconds")
    }
}

struct CPUFrequencyReadout: View {
    @ObservedObject var monitor: CPUFrequencyMonitor

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("CPU Frequency")
                .font(.caption).foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                if let reading = monitor.current {
                    Text(reading.hertz / 1_000_000_000, format: .number.precision(.fractionLength(2)))
                } else { Text("—") }
                Text("GHz").font(.subheadline).foregroundStyle(.secondary)
            }
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .monospacedDigit()
            frequencySamplingDescription(monitor)
                .font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FrequencySettingsView: View {
    @ObservedObject var monitor: CPUFrequencyMonitor

    var body: some View {
        Form {
            Section {
                Toggle("Show CPU frequency in the menu bar", isOn: Binding(
                    get: { monitor.showInMenuBar }, set: monitor.setShowInMenuBar))
                Picker("Sampling interval", selection: Binding(
                    get: { monitor.interval }, set: monitor.setInterval)) {
                    ForEach(CPUFrequencyMonitor.allowedIntervals, id: \.self) { seconds in
                        Text("\(seconds) seconds").tag(seconds)
                    }
                }
                Text("The menu bar, popover and chart share the same samples. Shorter intervals may use more energy.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Section("History") {
                Toggle("Record frequency history in the background", isOn: Binding(
                    get: { monitor.recordInBackground }, set: monitor.setRecordInBackground))
                Text("Keep up to one hour of history in memory while TurboKiller is running. When background recording is off, history is recorded only while the Frequency Monitor window is open.")
                    .font(.caption).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .formStyle(.grouped).padding()
    }
}

struct FrequencyHistoryView: View {
    @ObservedObject var monitor: CPUFrequencyMonitor
    @State private var minutes = 15
    @State private var selectedID: UUID?

    var body: some View {
        TimelineView(.periodic(from: .now, by: Double(monitor.interval))) { context in
            history(at: context.date)
        }
        .frame(minWidth: 540, minHeight: 340)
        .onAppear {
            monitor.setHistoryVisible(true)
            NSApp.activate(ignoringOtherApps: true)
        }
        .onDisappear { monitor.setHistoryVisible(false) }
    }

    private func history(at now: Date) -> some View {
        let start = now.addingTimeInterval(-Double(minutes * 60))
        let points = monitor.samples.filter { $0.reading.end >= start && $0.reading.end <= now }
        let bands = monitor.bands(from: start, to: now)
        let isolated = Set(Dictionary(grouping: points, by: \.segment)
            .values.filter { $0.count == 1 }.compactMap { $0.first?.id })
        let base = monitor.baseFrequencyHertz.map { $0 / 1_000_000_000 }
        let ceiling = max(4, max(points.map { $0.reading.hertz / 1_000_000_000 }.max() ?? 0, base ?? 0) * 1.1)
        let yTicks = frequencyTicks(ceiling: ceiling, base: base)
        let selected = points.first { $0.id == selectedID }
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                CPUFrequencyReadout(monitor: monitor)
                Spacer()
                Picker("Time range", selection: $minutes) {
                    Text("Last 5 minutes").tag(5)
                    Text("Last 15 minutes").tag(15)
                    Text("Last hour").tag(60)
                }
                .labelsHidden()
                .accessibilityLabel(Text("Time range"))
                .controlSize(.small)
                .frame(width: 155)
            }
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    legend("Turbo Boost enabled", color: .red).fixedSize()
                    legend("Turbo Boost disabled", color: .blue).fixedSize()
                    legend("Unknown / no samples", color: .gray).fixedSize()
                    if let base { baseFrequencyLegend(gigahertz: base).fixedSize() }
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 12) {
                        legend("Turbo Boost enabled", color: .red)
                        legend("Turbo Boost disabled", color: .blue)
                    }
                    HStack(spacing: 12) {
                        legend("Unknown / no samples", color: .gray)
                        if let base { baseFrequencyLegend(gigahertz: base) }
                    }
                }
            }
            .font(.system(size: 11))
            Chart {
                ForEach(bands) { band in
                    RectangleMark(xStart: .value("Start", band.start), xEnd: .value("End", band.end),
                                  yStart: .value("GHz", 0), yEnd: .value("GHz", ceiling))
                        .foregroundStyle(bandColor(band.status).opacity(0.10))
                        .accessibilityHidden(true)
                }
                if let base {
                    RuleMark(y: .value("Base Frequency", base))
                        .foregroundStyle(Color.secondary.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .accessibilityLabel(Text("Base Frequency"))
                        .accessibilityValue(frequencyAccessibilityValue(hertz: base * 1_000_000_000))
                }
                ForEach(points) { point in
                    LineMark(x: .value("Time", point.reading.end),
                             y: .value("GHz", point.reading.hertz / 1_000_000_000),
                             series: .value("Segment", point.segment))
                        .foregroundStyle(Color.accentColor)
                        .interpolationMethod(.linear)
                        .accessibilityLabel(Text("CPU Frequency"))
                        .accessibilityValue(frequencyAccessibilityValue(hertz: point.reading.hertz))
                }
                ForEach(points.filter { isolated.contains($0.id) }) { point in
                    PointMark(x: .value("Time", point.reading.end),
                              y: .value("GHz", point.reading.hertz / 1_000_000_000))
                        .foregroundStyle(Color.accentColor)
                }
                if let selected {
                    RuleMark(x: .value("Time", selected.reading.end))
                        .foregroundStyle(.secondary)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    PointMark(x: .value("Time", selected.reading.end),
                              y: .value("GHz", selected.reading.hertz / 1_000_000_000))
                        .foregroundStyle(Color.accentColor)
                }
            }
            .chartXScale(domain: start...now, range: .plotDimension(padding: 0))
            .chartYScale(domain: 0...ceiling)
            .chartYAxisLabel("GHz")
            .chartYAxis { frequencyAxis(ticks: yTicks, base: base) }
            .chartXAxis { AxisMarks(values: timeTicks(from: start, to: now)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour().minute(), anchor: .top,
                               collisionResolution: .greedy)
            } }
            .chartPlotStyle { $0.background(Color.secondary.opacity(0.035)) }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onContinuousHover { phase in
                            switch phase {
                            case .active(let location):
                                let frame = plotFrame(proxy: proxy, geometry: geometry)
                                guard frame.contains(location),
                                      let date: Date = proxy.value(atX: location.x - frame.minX) else {
                                    selectedID = nil; return
                                }
                                selectedID = points.first(where: {
                                    $0.reading.start <= date && $0.reading.end >= date
                                })?.id
                            case .ended: selectedID = nil
                            }
                        }
                }
            }
            .overlay {
                if points.isEmpty {
                    Text("Frequency history will appear as samples arrive.")
                        .font(.callout).foregroundStyle(.secondary)
                        .padding(12).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .frame(minHeight: 180)
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    if let selected {
                        Text(selected.reading.end, style: .time)
                        Text(selected.reading.hertz / 1_000_000_000, format: .number.precision(.fractionLength(2)))
                        Text("GHz")
                        Text(statusText(for: selected.reading))
                    } else {
                        Text("Hover over the chart to inspect a sample.")
                    }
                    Spacer(minLength: 0)
                }
                .lineLimit(1)
                .frame(height: 14, alignment: .leading)
                .monospacedDigit()
                Text("Session history only · Gaps indicate missing data.")
                    .fixedSize(horizontal: false, vertical: true)
                    .help(Text("History is kept for this session only. Gaps indicate sleep, paused monitoring or unavailable data."))
            }
            .font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .padding(16)
    }

    private func statusText(for reading: CPUFrequencyReading) -> LocalizedStringKey {
        let states = monitor.bands(from: reading.start, to: reading.end).map(\.status)
        guard let state = states.first, states.allSatisfy({ $0 == state }) else {
            return "Turbo Boost changed / unknown"
        }
        switch state {
        case .enabled: return "Turbo Boost enabled"
        case .disabled: return "Turbo Boost disabled"
        case .unavailable: return "Turbo Boost status unavailable"
        }
    }

    private func frequencyAccessibilityValue(hertz: Double) -> Text {
        let value = (hertz / 1_000_000_000).formatted(.number.precision(.fractionLength(2)))
        return Text("\(value) GHz")
    }

    private func frequencyAxis(ticks: [Double], base: Double?) -> some AxisContent {
        AxisMarks(position: .trailing, values: ticks) { value in
            if let base, let tick = value.as(Double.self), abs(tick - base) < 0.000001 {
                AxisTick()
                AxisValueLabel {
                    Text(base, format: .number.precision(.fractionLength(2)))
                        .foregroundStyle(.primary)
                }
            } else {
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0)))
            }
        }
    }

    /// Keep labels away from the two edges without shrinking the data range.
    private func timeTicks(from start: Date, to end: Date) -> [Date] {
        let duration = end.timeIntervalSince(start)
        let step: TimeInterval = minutes == 5 ? 60 : minutes == 15 ? 300 : 900
        let margin = duration * 0.06
        let first = ceil(start.addingTimeInterval(margin).timeIntervalSince1970 / step) * step
        return stride(from: first, through: end.addingTimeInterval(-margin).timeIntervalSince1970,
                      by: step).map(Date.init(timeIntervalSince1970:))
    }

    private func frequencyTicks(ceiling: Double, base: Double?) -> [Double] {
        let step = ceiling > 6 ? 2.0 : 1.0
        let regular = Array(stride(from: 0.0, through: ceiling, by: step))
        guard let base else { return regular }
        // Replace a nearby ordinary label to leave room for the precise value.
        return (regular.filter { abs($0 - base) > ceiling * 0.09 } + [base]).sorted()
    }

    private func baseFrequencyLegend(gigahertz: Double) -> some View {
        HStack(spacing: 5) {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 4))
                path.addLine(to: CGPoint(x: 14, y: 4))
            }
            .stroke(Color.secondary.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [3, 2]))
            .frame(width: 14, height: 8)
            (Text("Base Frequency") + Text(verbatim: " ")
             + Text(gigahertz, format: .number.precision(.fractionLength(2)))
             + Text(verbatim: " GHz"))
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
        .help(Text("The CPU's nominal base frequency, not its current, minimum or maximum frequency."))
    }

    private func plotFrame(proxy: ChartProxy, geometry: GeometryProxy) -> CGRect {
        if #available(macOS 14.0, *), let anchor = proxy.plotFrame {
            return geometry[anchor]
        } else {
            return geometry[proxy.plotAreaFrame]
        }
    }

    private func bandColor(_ status: TurboBoostStatus) -> Color {
        switch status {
        case .enabled: .red
        case .disabled: .blue
        case .unavailable: .gray
        }
    }

    private func legend(_ label: LocalizedStringKey, color: Color) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2).fill(color.opacity(0.15))
                .frame(width: 11, height: 11)
                .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(color.opacity(0.4)))
            Text(label)
        }
    }
}
