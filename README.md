# Codable Eextension
This extension provides various convenience methods to parse JSON more easily. When I first started writing code using 
`Codable` protocol, I could not parse a dictionry with `Any` value cause the `Any` does not conform to `Codable` protocol. This 
extension will help encode/decode dictionaries that may contain `Any` value.
