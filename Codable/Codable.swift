//
//  Codable.swift
//  Codable
//
//  Created by Avigit Saha on 9/15/17.
//  Copyright © 2019 Avigit Saha. All rights reserved.
//

import Foundation

extension JSONDecoder {
    open func decode<Type>(_ type: Type.Type, from jsonString: String) throws -> Type where Type : Decodable {
        guard let data = jsonString.data(using: .utf8) else {
            let error = NSError(domain: "JSONDecoder", code: 0, userInfo: [NSLocalizedDescriptionKey : "Error converting string to data"])
            throw error
        }
        return try decode(type, from: data)
    }
}

/// This extension help encode `Encodable` values into JSON using the given encoder.
extension Encodable {
    public func toJSONData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    public func toJSONString(encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try self.toJSONData(encoder: encoder)
        guard let string = String(data: data, encoding: .utf8) else {
            let error = NSError(domain: String(describing: self), code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to parse string from the JSON data."])
            throw error
        }
        
        return string
    }
    
    public func toJSON(encoder: JSONEncoder = JSONEncoder()) throws -> Any {
        let data = try self.toJSONData(encoder: encoder)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}

/// This extension help decode JSON representation using the given decoder.

extension Decodable {
    public init(JSONData data: Data, decoder: JSONDecoder = JSONDecoder()) throws {
        self = try decoder.decode(Self.self, from: data)
    }
    
    public init(JSONString jsonString: String, decoder: JSONDecoder = JSONDecoder()) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw CodableExtensionError.invalidJSONString
        }
        
        let obj = try decoder.decode(Self.self, from: data)
        self = obj
    }
    
    public init(JSON jsonObject: Any, decoder: JSONDecoder = JSONDecoder()) throws {
        
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        let obj = try decoder.decode(Self.self, from: data)
        self = obj
    }
}

// MARK: CodableExtensionError
enum CodableExtensionError: Error {
    case invalidJSONObject
    case invalidJSONString
}

// MARK: -
/// This extension will help encode `Dictionary<String, Any>` dictionaries normally like any other supported type
extension KeyedEncodingContainer {
    private struct CodingKeys: CodingKey {
        
        /// All these properties and initializers are required for `CodingKey` protocol
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    private mutating func encode(_ value: Any, forKey key: KeyedEncodingContainer.Key) throws {
        if let value = value as? Int {
            try encode(value, forKey: key)
        } else if let value = value as? Int8 {
            try encode(value, forKey: key)
        } else if let value = value as? Int16 {
            try encode(value, forKey: key)
        } else if let value = value as? Int32 {
            try encode(value, forKey: key)
        } else if let value = value as? Int64 {
            try encode(value, forKey: key)
        } else if let value = value as? UInt {
            try encode(value, forKey: key)
        } else if let value = value as? UInt8 {
            try encode(value, forKey: key)
        } else if let value = value as? UInt16 {
            try encode(value, forKey: key)
        } else if let value = value as? UInt32 {
            try encode(value, forKey: key)
        } else if let value = value as? UInt64 {
            try encode(value, forKey: key)
        } else if let value = value as? Float {
            try encode(value, forKey: key)
        } else if let value = value as? Double {
            try encode(value, forKey: key)
        } else if let value = value as? Bool {
            try encode(value, forKey: key)
        } else if let value = value as? String {
            try encode(value, forKey: key)
        } else if let value = value as? [String : Any] {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Bool> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Int> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Int8> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Int16> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Int32> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Int64> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<UInt> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<UInt8> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<UInt16> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<UInt32> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<UInt64> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Float> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<Double> {
            try encode(value, forKey: key)
        } else if let value = value as? Array<String> {
            try encode(value, forKey: key)
        } else {
            let context = EncodingError.Context(codingPath: [key], debugDescription: "Unsupported value type")
            throw EncodingError.invalidValue(value, context)
        }
    }
    
    
    public mutating func encode(_ value: [String: Any], forKey key: KeyedEncodingContainer.Key) throws {
        
        var nestedContainer = self.nestedContainer(keyedBy: CodingKeys.self, forKey: key)
        
        for (key, value) in value {
            if let codingKey = CodingKeys(stringValue: key) {
                try nestedContainer.encode(value, forKey: codingKey)
            }
        }
    }
}

/// This extension will help decode `Dictionary<String, Any>` dictionaries normally like any other supported type

extension KeyedDecodingContainer {
    
    private struct CodingKeys: CodingKey {
        
        /// All these properties and initializers are required for `CodingKey` protocol
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    public func decode(_ type: [String: Any].Type, forKey key: KeyedDecodingContainer.Key) throws -> [String: Any] {
        
        let values = try self.nestedContainer(keyedBy: CodingKeys.self, forKey: key)
        return try values.decode(type)
    }
    
    private func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        
        for key in self.allKeys {
            
            if let value = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int8.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int16.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int32.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int64.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(UInt.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(UInt8.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(UInt16.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(UInt32.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(UInt64.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Float.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([String : Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Bool>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Int>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Int8>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Int16>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Int32>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Int64>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<UInt>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<UInt8>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<UInt16>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<UInt32>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<UInt64>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Float>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<Double>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Array<String>.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else {
                let context = DecodingError.Context(codingPath: [key], debugDescription: "Unsupported type")
                throw DecodingError.typeMismatch(type, context)
            }
            
        }
        
        return dictionary
    }
}
