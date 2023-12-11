//
//  File.swift
//
//
//  Created by Bakr mohamed on 11/12/2023.
//

import Foundation

public struct Country: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let code: String
    public let dial_code: String
    public let flag: String
    
    public init(
        id: Int,
        name: String,
        code: String,
        dial_code: String,
        flag: String
    ) {
        self.id = id
        self.name = name
        self.code = code
        self.dial_code = dial_code
        self.flag = flag
    }
    
    
    public static var emptyCountry: Self {
        .init(
            id: 0,
            name: "",
            code: "",
            dial_code: "",
            flag: ""
        )
    }
}
