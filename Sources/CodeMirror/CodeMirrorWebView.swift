import Foundation
import WebKit

#if canImport(AppKit)
    import AppKit
    public typealias NativeView = NSView
#elseif canImport(UIKit) && !os(watchOS)
    import UIKit
    public typealias NativeView = UIView
#endif

public protocol CodeMirrorWebViewDelegate: AnyObject {
    func codeMirrorViewDidLoadSuccess(_ sender: CodeMirrorWebView)
    func codeMirrorViewDidLoadError(_ sender: CodeMirrorWebView, error: Error)
    func codeMirrorViewDidChangeContent(_ sender: CodeMirrorWebView, content: String)
}

public final class CodeMirrorWebView: NativeView {
    public weak var delegate: CodeMirrorWebViewDelegate?

    private lazy var webview: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        var userController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = userController
        let webView = WKWebView(frame: bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground")  // Prevent white flick
        return webView
    }()

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        webview.allowsMagnification = false
        webview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webview)

        NSLayoutConstraint.activate([
            webview.leadingAnchor.constraint(equalTo: leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: trailingAnchor),
            webview.topAnchor.constraint(equalTo: topAnchor),
            webview.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])

        let indexURL = Bundle.module.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "build"
        )
        let baseURL = Bundle.module.url(forResource: "build", withExtension: nil)

        let data = try! Data.init(contentsOf: indexURL!)
        webview.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: baseURL!)
    }
}

// MARK: WKNavigationDelegate

extension CodeMirrorWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.codeMirrorViewDidLoadSuccess(self)
    }

    public func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        delegate?.codeMirrorViewDidLoadError(self, error: error)
    }

    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        delegate?.codeMirrorViewDidLoadError(self, error: error)
    }
}
