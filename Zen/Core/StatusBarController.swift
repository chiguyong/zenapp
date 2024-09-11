import AppKit
import SwiftUI

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var menu: NSMenu
    private weak var appDelegate: AppDelegate?

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        menu = NSMenu()

        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: "Zen")
        }

        setupMenu()
    }

    func setupMenu() {
        let toggleItem = NSMenuItem(title: "显示/隐藏 Zen", action: #selector(toggleZen), keyEquivalent: "t")
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "退出", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc func toggleZen() {
        print("toggleZen called")
        appDelegate?.toggleMainWindow()
    }

    @objc func quitApp() {
        print("quitApp called")
        NSApplication.shared.terminate(nil)
    }
}
