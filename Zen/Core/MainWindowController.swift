import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSWindowDelegate {
    
    convenience init() {
        let contentRect: NSRect
        if let savedFrame = MainWindowController.loadWindowFrame() {
            contentRect = savedFrame
            print("Using saved frame: \(savedFrame)")
        } else {
            let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
            contentRect = NSRect(x: screenFrame.midX - 150, y: screenFrame.midY - 150, width: 300, height: 300)
            print("Using default frame: \(contentRect)")
        }
        
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        self.init(window: window)
        
        window.delegate = self
        window.title = "Zen"
        
        let contentView = ContentView()
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = window.contentRect(forFrameRect: window.frame)
        window.contentView = hostingView
        
        window.minSize = NSSize(width: 300, height: 300)
        
        print("Window initialized with frame: \(window.frame)")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        print("Window did load with frame: \(window?.frame ?? .zero)")
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        NSApp.setActivationPolicy(.accessory)
        return false
    }
    
    func windowDidResize(_ notification: Notification) {
        if let window = self.window {
            print("Window resized to: \(window.frame)")
            MainWindowController.saveWindowFrame(window.frame)
        }
    }
    
    func windowDidMove(_ notification: Notification) {
        if let window = self.window {
            print("Window moved to: \(window.frame)")
            MainWindowController.saveWindowFrame(window.frame)
        }
    }
    
    static private func saveWindowFrame(_ frame: NSRect) {
        let frameString = NSStringFromRect(frame)
        UserDefaults.standard.set(frameString, forKey: "MainWindowFrame")
        print("Saved window frame: \(frameString)")
    }
    
    static private func loadWindowFrame() -> NSRect? {
        guard let frameString = UserDefaults.standard.string(forKey: "MainWindowFrame") else { return nil }
        let frame = NSRectFromString(frameString)
        print("Loaded window frame: \(frame)")
        return frame
    }
}
