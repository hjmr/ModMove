import AppKit
import Foundation

enum FlagState {
    case Resize
    case Drag
    case Ignore
}

final class Observer {
    private var monitor: Any?

    func startObserving(state: @escaping (FlagState) -> Void) {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            state(self.state(for: event.modifierFlags))
        }
    }

    private func state(for flags: NSEvent.ModifierFlags) -> FlagState {
        let hasControl = flags.contains(.control)
        let hasOption = flags.contains(.option)
        let hasShift = flags.contains(.shift)
        let hasCommand = flags.contains(.command)

        if hasShift && hasOption {
            return .Resize
        } else if hasShift && hasCommand {
            return .Drag
        } else {
            return .Ignore
        }
    }

    deinit {
        if let monitor = self.monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
