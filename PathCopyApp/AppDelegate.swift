import Cocoa
import FinderSync

@MainActor
@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow?
    private let statusLabel = NSTextField(labelWithString: "")

    func applicationDidFinishLaunching(_ notification: Notification) {
        showWindow()
        refreshStatus()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        refreshStatus()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func showWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 260),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "PathCopy"
        window.center()

        let title = NSTextField(labelWithString: "Finder 右键复制完整路径")
        title.font = .systemFont(ofSize: 22, weight: .semibold)

        let body = NSTextField(wrappingLabelWithString: "启用扩展后，在 Finder 中右键文件或文件夹，选择“复制完整路径”。多选时会按行复制多个路径。")
        body.font = .systemFont(ofSize: 14)
        body.textColor = .secondaryLabelColor

        statusLabel.font = .systemFont(ofSize: 13)

        let openButton = NSButton(title: "打开扩展设置", target: self, action: #selector(openExtensionSettings))
        openButton.bezelStyle = .rounded

        let stack = NSStackView(views: [title, body, statusLabel, openButton])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        window.contentView?.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: window.contentView!.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: window.contentView!.trailingAnchor, constant: -32),
            stack.centerYAnchor.constraint(equalTo: window.contentView!.centerYAnchor)
        ])

        self.window = window
        window.makeKeyAndOrderFront(nil)
    }

    private func refreshStatus() {
        statusLabel.stringValue = FIFinderSyncController.isExtensionEnabled
            ? "状态：Finder 扩展已启用"
            : "状态：Finder 扩展未启用"
    }

    @objc private func openExtensionSettings() {
        FIFinderSyncController.showExtensionManagementInterface()
    }
}
