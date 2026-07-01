import Cocoa
import FinderSync

final class FinderSyncExtension: FIFinderSync {
    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        let menu = NSMenu(title: "")
        let item = NSMenuItem(title: "复制完整路径", action: #selector(copyFullPath), keyEquivalent: "")
        item.target = self
        item.isEnabled = !finderURLs().isEmpty
        menu.addItem(item)
        return menu
    }

    @objc private func copyFullPath() {
        let paths = finderURLs().map(\.path).joined(separator: "\n")
        guard !paths.isEmpty else { return }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(paths, forType: .string)
    }

    private func finderURLs() -> [URL] {
        let controller = FIFinderSyncController.default()
        if let selected = controller.selectedItemURLs(), !selected.isEmpty {
            return selected
        }
        return controller.targetedURL().map { [$0] } ?? []
    }
}

