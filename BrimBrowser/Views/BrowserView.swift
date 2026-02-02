//
//  BrowserView.swift
//  BrimBrowser
//
//  Created by Devansh Rai on 17/9/25.
//
import SwiftUI

struct BrowserView: View {
    @StateObject var tabManager = TabManager()
    @StateObject var bookmarkManager = BookmarkManager()
    @FocusState private var isAddressBarFocused: Bool
    @State private var hoveredTab: UUID?

    var body: some View {
        VStack(spacing: 0) {
            unifiedToolbar
            
            if let currentTab = tabManager.currentTab, currentTab.url.isEmpty {
                HomePage(onSearch: { query in
                    tabManager.addressBarText = query
                    tabManager.loadCurrent()
                }, bookmarks: bookmarkManager.bookmarks)
            } else {
                contentArea
            }
        }
        .background(.ultraThinMaterial) // frosted Safari look
        .background(
            Group {
                // MARK: - Navigation Shortcuts
                Button("") { tabManager.addTab() }.keyboardShortcut("t", modifiers: .command) // New Tab
                Button("") { if let tab = tabManager.currentTab { tabManager.closeTab(tab) } }.keyboardShortcut("w", modifiers: .command) // Close Tab
                Button("") { isAddressBarFocused = true }.keyboardShortcut("l", modifiers: .command) // Open Location
                Button("") { tabManager.currentTab?.webView.reload() }.keyboardShortcut("r", modifiers: .command) // Reload Page
                Button("") { tabManager.currentTab?.webView.goBack() }.keyboardShortcut("[", modifiers: .command) // Back
                Button("") { tabManager.currentTab?.webView.goForward() }.keyboardShortcut("]", modifiers: .command) // Forward
                
                // Tab Switching
                Button("") { tabManager.nextTab() }.keyboardShortcut("]", modifiers: [.command, .shift]) // Next Tab
                Button("") { tabManager.previousTab() }.keyboardShortcut("[", modifiers: [.command, .shift]) // Previous Tab
                Button("") { tabManager.nextTab() }.keyboardShortcut(.tab, modifiers: .control) // Ctrl+Tab
                Button("") { tabManager.previousTab() }.keyboardShortcut(.tab, modifiers: [.control, .shift]) // Ctrl+Shift+Tab

                // Select Tab 1-9
                Button("") { tabManager.switchToIndex(0) }.keyboardShortcut("1", modifiers: .command)
                Button("") { tabManager.switchToIndex(1) }.keyboardShortcut("2", modifiers: .command)
                Button("") { tabManager.switchToIndex(2) }.keyboardShortcut("3", modifiers: .command)
                Button("") { tabManager.switchToIndex(3) }.keyboardShortcut("4", modifiers: .command)
                Button("") { tabManager.switchToIndex(4) }.keyboardShortcut("5", modifiers: .command)
                Button("") { tabManager.switchToIndex(5) }.keyboardShortcut("6", modifiers: .command)
                Button("") { tabManager.switchToIndex(6) }.keyboardShortcut("7", modifiers: .command)
                Button("") { tabManager.switchToIndex(7) }.keyboardShortcut("8", modifiers: .command)
                Button("") { tabManager.switchToIndex(8) }.keyboardShortcut("9", modifiers: .command)

                // MARK: - Zoom In Zoom Out
                // Cmd + + (standard) and Cmd + = 
                Button("") { tabManager.currentTab?.webView.zoomIn() }.keyboardShortcut("=", modifiers: .command)
                Button("") { tabManager.currentTab?.webView.zoomOut() }.keyboardShortcut("-", modifiers: .command)
                Button("") { tabManager.currentTab?.webView.resetZoom() }.keyboardShortcut("0", modifiers: .command)
                
                // MARK: - Utility
                // Copy URL Shortcut
                Button("") {
                    if let url = tabManager.currentTab?.url {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(url, forType: .string)
                    }
                }.keyboardShortcut("c", modifiers: [.command, .shift]) // Cmd+Shift+C for copy full URL specifically
            }
            .opacity(0)
        )

    }

    // MARK: - Unified Toolbar
    private var unifiedToolbar: some View {
        HStack(spacing: 12) {
            // 1. Navigation Controls
            HStack(spacing: 6) {
                Button(action: { tabManager.currentTab?.webView.goBack() }) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.borderless)
                
                Button(action: { tabManager.currentTab?.webView.goForward() }) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderless)
                
                Button(action: { tabManager.currentTab?.webView.reload() }) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.borderless)
            }
            .foregroundColor(.secondary)

            // 2. Address Bar (Compact Fixed Width)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                TextField("Search or URL",
                          text: $tabManager.addressBarText,
                          onCommit: { tabManager.loadCurrent() })
                    .textFieldStyle(.plain)
                    .focused($isAddressBarFocused)
                    .disableAutocorrection(true)
            }
            .padding(6)
            .frame(width: 260) // Fixed width to allow room for tabs
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
            )

            // 3. Horizontal Scrollable Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(tabManager.tabs) { tab in
                        compactTabButton(tab)
                            .transition(.opacity)
                    }
                }
            }
            .frame(maxWidth: .infinity) // Take up remaining space

            // 4. Utility Buttons (New Tab, Bookmarks)
            HStack(spacing: 8) {
                Button(action: { tabManager.addTab() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.borderless)

                Menu {
                    Button(action: {
                        if let current = tabManager.currentTab, !current.url.isEmpty {
                            bookmarkManager.addBookmark(title: current.title, url: current.url)
                        }
                    }) {
                        Label("Add Bookmark", systemImage: "plus")
                    }
                    
                    if !bookmarkManager.bookmarks.isEmpty {
                        Divider()
                        
                        ForEach(bookmarkManager.bookmarks) { bm in
                            Button(bm.title) {
                                tabManager.addressBarText = bm.url
                                tabManager.loadCurrent()
                            }
                        }
                    }
                } label: {
                    Image(systemName: "bookmark")
                        .font(.system(size: 14, weight: .medium))
                }
                .menuStyle(.borderlessButton)
            }
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .overlay(Divider(), alignment: .bottom)
    }

    // MARK: - Compact Tab Button
    private func compactTabButton(_ tab: BrowserTab) -> some View {
        HStack(spacing: 6) {
            // Favicon placeholder or site initial
            Circle()
                .fill(Color.secondary.opacity(0.2))
                .frame(width: 12, height: 12)
            
            Text(tab.title)
                .lineLimit(1)
                .font(.system(size: 12))
            
            // Close Button (Only show on hover or active)
            if tabManager.currentTab?.id == tab.id || hoveredTab == tab.id {
                Button(action: { withAnimation { tabManager.closeTab(tab) } }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.borderless)
                .padding(2)
                .background(Color.primary.opacity(0.05))
                .clipShape(Circle())
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            tabManager.currentTab?.id == tab.id
            ? Color.primary.opacity(0.1)
            : (hoveredTab == tab.id ? Color.primary.opacity(0.05) : Color.clear)
        )
        .cornerRadius(6)
        .onTapGesture {
            withAnimation {
                tabManager.switchToTab(tab)
            }
        }
        .onHover { hovering in
            if hovering {
                hoveredTab = tab.id
            } else {
                hoveredTab = nil
            }
        }
    }

    // MARK: - Content Area
    private var contentArea: some View {
        Group {
            if let currentTab = tabManager.currentTab {
                WebViewContainer(webView: currentTab.webView.webView)
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                Text("No Tab Open")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}

// MARK: - Home Page
struct HomePage: View {
    var onSearch: (String) -> Void
    var bookmarks: [Bookmark]

    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Brim Browser")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search or enter website", text: $searchText, onCommit: {
                    onSearch(searchText)
                })
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
            }
            .padding(12)
            .frame(maxWidth: 500)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(radius: 2)

            if !bookmarks.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Favorites")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 20) {
                        ForEach(bookmarks.prefix(6)) { bm in
                            VStack {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(Image(systemName: "bookmark"))
                                Text(bm.title)
                                    .lineLimit(1)
                                    .font(.caption)
                            }
                            .onTapGesture { onSearch(bm.url) }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}
