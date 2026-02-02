//
//  TabManager.swift
//  BrimBrowser
//
//  Created by Devansh Rai on 17/9/25.
//

import Foundation

final class TabManager: ObservableObject {
    @Published var tabs: [BrowserTab] = []
    @Published var currentTab: BrowserTab?
    @Published var addressBarText: String = ""

    init() {
        addTab() // start with one tab open
    }

    func addTab() {
        let webView = WebViewManager()
        let newTab = BrowserTab(title: "Home", url: "", webView: webView)
        tabs.append(newTab)
        currentTab = newTab
        addressBarText = ""
    }

    func closeTab(_ tab: BrowserTab) {
        tabs.removeAll { $0.id == tab.id }
        if currentTab?.id == tab.id {
            currentTab = tabs.last
            addressBarText = currentTab?.url ?? ""
        }
    }

    func switchToTab(_ tab: BrowserTab) {
        currentTab = tab
        addressBarText = tab.url
    }

    func nextTab() {
        guard let current = currentTab, let index = tabs.firstIndex(where: { $0.id == current.id }) else { return }
        let nextIndex = (index + 1) % tabs.count
        switchToTab(tabs[nextIndex])
    }

    func previousTab() {
        guard let current = currentTab, let index = tabs.firstIndex(where: { $0.id == current.id }) else { return }
        let prevIndex = (index - 1 + tabs.count) % tabs.count
        switchToTab(tabs[prevIndex])
    }

    func switchToIndex(_ index: Int) {
        guard index >= 0 && index < tabs.count else { return }
        switchToTab(tabs[index])
    }

    func loadCurrent() {
        guard let currentTab = currentTab else { return }
        var input = addressBarText.trimmingCharacters(in: .whitespacesAndNewlines)

        if input.isEmpty {
            return
        }

        // If input looks like a URL (contains a dot or starts with http)
        if input.starts(with: "http://") || input.starts(with: "https://") {
            // valid full URL
        } else if input.contains(".") && !input.contains(" ") {
            input = "https://\(input)"
        } else {
            // Treat as DuckDuckGo search (Privacy First)
            let query = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? input
            input = "https://duckduckgo.com/?q=\(query)"
        }

        currentTab.webView.load(input)
        currentTab.url = input
    }
}
