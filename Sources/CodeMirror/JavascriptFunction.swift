public typealias JavascriptCallback = (Result<Any?, Error>) -> Void

public struct JavascriptFunction {

    public let functionString: String
    public let args: [String: Any]

    public init(
        functionString: String,
        args: [String: Any] = [:]
    ) {
        self.functionString = functionString
        self.args = args
    }
}
