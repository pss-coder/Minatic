//
//  Type.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import Foundation

enum Type: String, CaseIterable, Codable, Identifiable {
    case standup
    case test1
    case test2
    
    var name: String {
        rawValue.capitalized
    }
    
    var id: String {
        name
    }
}
