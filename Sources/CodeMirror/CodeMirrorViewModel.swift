import SwiftUI

@MainActor
public class CodeMirrorViewModel: ObservableObject {
    public var onLoadSuccess: (() -> Void)?
    public var onLoadFailed: ((Error) -> Void)?
    public var onContentChange: (() -> Void)?

    internal var executeJS: ((JavascriptFunction, JavascriptCallback?) -> Void)!

    private func executeJSAsync<T>(f: JavascriptFunction) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            executeJS(f) { result in
                continuation.resume(with: result.map { $0 as? T })
            }
        }
    }

    public func getContent() async throws -> String? {
        try await executeJSAsync(
            f: JavascriptFunction(
                functionString: "CodeMirror.getContent()"
            )
        )
    }

    public func setContent(_ value: String) {
        executeJS(
            JavascriptFunction(
                functionString: "CodeMirror.setContent(value)",
                args: ["value": value]
            ),
            nil
        )
    }

    public func setDarkMode(on: Bool) {
        executeJS(
            JavascriptFunction(functionString: "CodeMirror.setDarkMode(on)", args: ["on": on]),
            nil
        )
    }

    public func setLanguage(_ lang: String) {
        executeJS(
            JavascriptFunction(functionString: "CodeMirror.setLanguage(\"\(lang)\")"),
            nil
        )
    }

    public func getSupportedLanguages(_ callback: JavascriptCallback?) {
        executeJS(
            JavascriptFunction(
                functionString: "CodeMirror.getSupportedLanguages()"
            ),
            callback
        )
    }

    public func setReadonly(_ value: Bool) {
        executeJS(
            JavascriptFunction(
                functionString: "CodeMirror.setReadOnly(value)",
                args: ["value": value]
            ),
            nil
        )
    }

    public func setLineWrapping(_ enabled: Bool) {
        executeJS(
            JavascriptFunction(
                functionString: "CodeMirror.setLineWrapping(enabled)",
                args: ["enabled": enabled]
            ),
            nil
        )
    }

    public init(
        onLoadSuccess: (() -> Void)? = nil,
        onLoadFailed: ((Error) -> Void)? = nil,
        onContentChange: (() -> Void)? = nil
    ) {
        self.onLoadSuccess = onLoadSuccess
        self.onLoadFailed = onLoadFailed
        self.onContentChange = onContentChange
    }
}
