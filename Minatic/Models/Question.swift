//
//  Question.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import Foundation

class Question: Identifiable, Codable, ObservableObject {
    var id: UUID
    var question: String
    @Published var isAnswered: Bool = false
    var response: String = ""
    
    init(id: UUID = UUID(), _ question: String) {
        self.id = id
        self.question = question
    }
    
    
    enum CodingKeys: CodingKey {
            case id
            case question
            case isAnswered
            case response
        }

        required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try values.decode(UUID.self, forKey: .id)
            self.question = try values.decode(String.self, forKey: .question)
            self.isAnswered = try values.decode(Bool.self, forKey: .isAnswered)
            self.response = try values.decode(String.self, forKey: .response)
        }

        func encode(to encoder: Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            
            try values.encode(self.id, forKey: .id)
            try values.encode(self.question, forKey: .question)
            try values.encode(self.isAnswered, forKey: .isAnswered)
            try values.encode(self.response, forKey: .response)
        }
}
