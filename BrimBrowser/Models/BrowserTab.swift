//
//  BrowserTab.swift
//  BrimBrowser
//
//  Created by Devansh Rai on 17/9/25.
//

import Foundation
import Combine

final class BrowserTab: Identifiable, ObservableObject {
    let id = UUID()
    @Published var title: String
    @Published var url: String
    var webView: WebViewManager
    private var cancellables = Set<AnyCancellable>()

    init(title: String, url: String, webView: WebViewManager) {
        self.title = title
        self.url = url
        self.webView = webView
        
        // Sync title from WebViewManager
        webView.$title
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTitle in
                self?.title = newTitle
            }
            .store(in: &cancellables)
    }
}
