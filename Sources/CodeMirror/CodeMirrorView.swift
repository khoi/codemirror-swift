import SwiftUI
import WebKit

#if canImport(AppKit)
    public typealias NativeView = NSViewRepresentable
#elseif canImport(UIKit)
    public typealias NativeView = UIViewRepresentable
#endif

public struct CodeMirrorView: NativeView {
    @ObservedObject public var viewModel: CodeMirrorViewModel

    public init(_ viewModel: CodeMirrorViewModel) {
        self.viewModel = viewModel
    }

    #if canImport(AppKit)
        public func makeNSView(context: Context) -> WKWebView {
            createWebView(context: context)
        }

        public func updateNSView(_ nsView: WKWebView, context: Context) {
            updateWebView(context: context)
        }
    #elseif canImport(UIKit)
        public func makeUIView(context: Context) -> WKWebView {
            createWebView(context: context)
        }

        public func updateUIView(_ nsView: WKWebView, context: Context) {
            updateWebView(context: context)
        }
    #endif

    private func createWebView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        let userController = WKUserContentController()
        userController.add(context.coordinator, name: ScriptMessageName.codeMirrorDidReady)
        userController.add(context.coordinator, name: ScriptMessageName.codeMirrorContentDidChange)

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = userController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        #if os(OSX)
            webView.setValue(false, forKey: "drawsBackground")  // prevent white flicks
            webView.allowsMagnification = false
        #elseif os(iOS)
            webView.isOpaque = false
        #endif

        let indexURL = Bundle.module.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "build"
        )

        let baseURL = Bundle.module.url(forResource: "build", withExtension: nil)
        let data = try! Data.init(contentsOf: indexURL!)
        webView.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: baseURL!)
        context.coordinator.webView = webView
        return webView
    }

    private func updateWebView(context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

public class Coordinator: NSObject {
    var parent: CodeMirrorView
    var webView: WKWebView!

    private var pageLoaded = false
    private var pendingFunctions = [JavascriptFunction]()

    init(parent: CodeMirrorView) {
        self.parent = parent
    }

    public func getContent(_ callback: JavascriptCallback?) {
        queueJavascriptFunction(
            JavascriptFunction(
                functionString: "CodeMirror.getContent()",
                callback: callback
            )
        )
    }

    public func setContent(_ value: String) {
        queueJavascriptFunction(
            JavascriptFunction(
                functionString: "CodeMirror.setContent(value)",
                args: ["value": value]
            )
        )
    }

    public func setDarkMode(on: Bool) {
        queueJavascriptFunction(
            JavascriptFunction(functionString: "CodeMirror.setDarkMode(on)", args: ["on": on])
        )
    }

    public func setLanguage(_ lang: String) {
        queueJavascriptFunction(
            JavascriptFunction(functionString: "CodeMirror.setLanguage(\"\(lang)\")")
        )
    }

    public func getSupportedLanguages(_ callback: JavascriptCallback?) {
        queueJavascriptFunction(
            JavascriptFunction(
                functionString: "CodeMirror.getSupportedLanguages()",
                callback: callback
            )
        )
    }

    public func setReadonly(_ value: Bool) {
        queueJavascriptFunction(
            JavascriptFunction(
                functionString: "CodeMirror.setReadOnly(value)",
                args: ["value": value]
            )
        )
    }

    public func setLineWrapping(_ enabled: Bool) {
        queueJavascriptFunction(
            JavascriptFunction(
                functionString: "CodeMirror.setLineWrapping(enabled)",
                args: ["enabled": enabled]
            )
        )
    }

    private func queueJavascriptFunction(_ function: JavascriptFunction) {
        if pageLoaded {
            evaluateJavascript(function: function)
        }
        else {
            pendingFunctions.append(function)
        }
    }

    private func callPendingFunctions() {
        for function in pendingFunctions {
            evaluateJavascript(function: function)
        }
        pendingFunctions.removeAll()
    }

    private func evaluateJavascript(function: JavascriptFunction) {
        // not sure why but callAsyncJavaScript always callback with result of nil
        if let callback = function.callback {
            webView.evaluateJavaScript(function.functionString) { (response, error) in
                if let error = error {
                    callback(.failure(error))
                }
                else {
                    callback(.success(response))
                }
            }
        }
        else {
            webView.callAsyncJavaScript(
                function.functionString,
                arguments: function.args,
                in: nil,
                in: .page
            ) { (result) in
                switch result {
                case .failure(let error):
                    function.callback?(.failure(error))
                case .success(let data):
                    function.callback?(.success(data))
                }
            }
        }
    }
}

extension Coordinator: WKScriptMessageHandler {
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        switch message.name {
        case ScriptMessageName.codeMirrorDidReady:
            pageLoaded = true
            callPendingFunctions()
        case ScriptMessageName.codeMirrorContentDidChange:
            parent.viewModel.onContentChange?()
        default:
            print("CodeMirrorWebView receive \(message.name) \(message.body)")
        }
    }
}

extension Coordinator: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.viewModel.onLoadSuccess?()
    }

    public func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        parent.viewModel.onLoadFailed?(error)
    }

    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        parent.viewModel.onLoadFailed?(error)
    }
}
