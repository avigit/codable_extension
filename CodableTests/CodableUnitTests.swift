//
//  CodableTests.swift
//  CodableTests
//
//  Created by Avigit Saha on 12/1/17.
//  Copyright © 2019 Avigit Saha. All rights reserved.
//

import XCTest
@testable import Codable

private struct Team: Codable {
    var name: String
    var numberOfPeople: Int
    var metadata: [String: Any]
    
    enum CodingKeys: String, CodingKey {
        case name
        case numberOfPeople
        case metadata
    }
    
    init(name: String, numberOfPeople: Int, metadata: [String: Any]) {
        self.name = name
        self.numberOfPeople = numberOfPeople
        self.metadata = metadata
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(numberOfPeople, forKey: .numberOfPeople)
        try container.encode(metadata, forKey: .metadata)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.numberOfPeople = try values.decode(Int.self, forKey: .numberOfPeople)
        self.metadata = try values.decode([String : Any].self, forKey: .metadata)
    }
}

extension Team: Equatable {
    static func ==(lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name &&
            lhs.numberOfPeople == rhs.numberOfPeople &&
            NSDictionary(dictionary: lhs.metadata).isEqual(to: rhs.metadata)
    }
}

class CodableUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testObjectCodabilityWithStringAnyDictionary() {
        let metadata: [String: Any] = [
            "color": "black",
            "isCoolTeam": true,
            "members": ["Avigit", "Ben", "Basheer", "Chris", "Colin", "Elliott", "Lea", "Prabin"],
            "other": [
                "numberOfDesigners": 1
            ]
        ]
        
        let actualTeam = Team(name: "MobileMcMobileFace", numberOfPeople: 10, metadata: metadata)
        
        guard let json = try? actualTeam.toJSONData() else {
            XCTFail("Encoding object with [String: Any] dictionary failed")
            return
        }
        
        let expectedTeam = try? Team(JSONData: json)
        
        XCTAssert(actualTeam == expectedTeam, "Failed to encode or decode correctly")
    }
    
}
