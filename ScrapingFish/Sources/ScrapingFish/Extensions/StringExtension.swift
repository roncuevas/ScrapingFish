extension String {
    var inBraces: Self {
        "{\(self)}"
    }
    
    var inBrackets: Self {
        "[\(self)]"
    }
    
    var inQuotes: Self {
        "\"\(self)\""
    }
    
    var colon: Self {
        "\(self):"
    }
    
    var comma: Self {
        "\(self),"
    }
    
    static func keyValue(_ key: String, _ value: String) -> String {
        "\(key):\(value)"
    }
}
