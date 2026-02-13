# 🌐 BrimBrowser

BrimBrowser is a modern, lightweight macOS browser born from a desire to refine the Safari experience and champion the **WebKit** engine in a market dominated by Chromium.

Built with **SwiftUI** and **WKWebView**, it offers a minimal, fast, and highly customizable environment for users who value the efficiency of the native Apple web stack.

Following a philosophy of being **"Lightweight, Safe, and Invisible,"** BrimBrowser is tailored for development tasks and power users who need a memory-efficient alternative that respects privacy without the bloat.

**_Archived!_**
> The project is now available under Swift Browser repository here: [nightguarder/Swift-Browser](https://github.com/nightguarder/Swift-Browser)
---

## ✨ Features

- 🖥️ **macOS Native UI** — Built with SwiftUI, optimized for macOS with a "glassy" `.ultraThinMaterial` aesthetic.
- 🛡️ **Privacy & Performance**
  - **DuckDuckGo** default search.
  - **Native Content Blocker** using `WKContentRuleListStore`.
  - **Shared Process Pool** (`WKProcessPool`) for reduced memory footprint.
- 📑 **Multiple Tabs** — Open, close, and switch tabs with smooth animations and background tab suspension.
- 🔖 **Bookmarks** — Save and quickly access your favorite sites.
- 🔍 **Smart Address Bar** — Enter URLs or search terms directly.
- 🚀 **Shortcuts** — Designed for speed with power-user keyboard shortcuts:
  - `⌘L` Focus Address Bar
  - `⌘[` / `⌘]` Back / Forward
  - `⇧⌘[` / `⇧⌘]` Switch Tabs
  - `⌘C` Copy URL (when address bar focused)

---

## 📸 Screenshots

> _(Add screenshots of your browser here — splash screen, homepage, tab bar, browsing view)_

- Splash Screen
- Homepage
- Browsing with Tabs

---

## 🛠️ Installation & Development

### Prerequisites

- macOS (Ventura or newer recommended)
- Xcode 15+
- Swift 5.9+

### For Developers

#### Build & Run in Xcode

1. Clone the repo:
   ```bash
   git clone https://github.com/idevanshrai/BrimBrowser-MacOS.git
   cd BrimBrowser-MacOS
   ```
2. Open `BrimBrowser.xcodeproj` in Xcode.
3. Select the `BrimBrowser` scheme and your Mac as the destination.
4. Press `⌘R` to build and run.

#### Manual Build & Run (Command Line)

To build and run the project manually from the terminal, you can use `xcodebuild`:

```bash
# 0. *Skip if added* Add Command Line Tools to path
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 1. Build the app
xcodebuild -project BrimBrowser.xcodeproj -scheme BrimBrowser -configuration Debug build

# 2. Run the app
open build/Debug/BrimBrowser.app
```

> **Note:** The exact output path might vary depending on your Xcode settings (e.g., if using a custom `DerivedData` path). By default, it builds into the project's `build/` folder if configured, or `~/Library/Developer/Xcode/DerivedData`.

---

## 📂 Project Structure

```
BrimBrowser/
├─ Managers/
│  ├─ TabManager.swift            # Handles tab state and navigation
│  └─ ContentBlockerManager.swift # Native ad/tracker blocking
├─ Models/
│  ├─ BrowserTab.swift            # Tab data model
│  └─ BookmarkManager.swift       # Bookmark persistence
├─ Views/
│  ├─ BrowserView.swift           # Main browser interface
│  ├─ SplashScreen.swift          # Animated startup
│  └─ WebViewContainer.swift      # WKWebView SwiftUI wrapper
├─ WebViewStore/
│  └─ WebViewManager.swift        # WebView lifecycle and process pool
├─ BrimBrowserApp.swift           # App entry point
└─ ContentView.swift              # Root view controller
```

---

## 🚧 Roadmap

### Memory & Performance

- [ ] **Tab Suspension Engine** — Auto-discard background tabs after 15 mins.
- [ ] **Singleton Configuration** — Optimized resource allocation.

### Privacy & Security

- [ ] **HTTPS Upgrade** — Force secure connections globally.
- [ ] **Cookie Nuke** — One-click session and cookie clearing.
- [ ] **User Agent Spoofing** — Enhanced privacy and developer testing.

### UI & UX

- [ ] **Unified Toolbar** — Compact design to maximize vertical space.
- [ ] **Keyboard Shortcuts** — `Cmd+L` (Focus), `Cmd+Shift+[` (Switch tabs), etc.
- [ ] **Settings Menu** — Privacy toggles and search engine customization.
- [ ] **History Support** — 30-day auto-purging history.
- [ ] **Zoom Controls** — `Cmd +/-` text and page zooming.

### Developer Tools

- [ ] **Integrated Web Inspector** — Native toggle for WebKit developer tools.
- [ ] **Console Log Overlay** — View JS errors and logs directly in the UI.
- [ ] **Responsive Design Mode** — Quickly test sites against common device breakpoints.
- [ ] **Network Monitor** — Lightweight inspection of resource loading and performance.

### Extensibility

- [ ] **Safari Web Extensions Support** — Compatibility with existing WebKit-based extensions.
- [ ] **API for Automation** — Scriptable browser actions via AppleScript or local API.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to fork the repo and submit pull requests.

---

## 📜 License

This project is licensed under the **MIT License**.
See [LICENSE](LICENSE) for details.

---
