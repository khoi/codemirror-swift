public typealias JavascriptCallback = (Result<Any?, Error>) -> Void
public struct JavascriptFunction {

    public let functionString: String
    public let args: [String: Any]
    public let callback: JavascriptCallback?

    public init(functionString: String, args: [String: Any] = [:], callback: JavascriptCallback? = nil) {
        self.functionString = functionString
        self.args = args
        self.callback = callback
    }
}
