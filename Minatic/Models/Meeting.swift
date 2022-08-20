//
//  Meeting.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import Foundation

struct Meeting: Identifiable, Codable {
    
    let id: UUID
    var title: String
    var attendees: [Attendee] = []
    var lengthInMinutes: Int = 0
    var theme: Theme
    var type: Type
    var history: [History] = []
    var schedule: Date = Date.now
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme, type: Type) {
        self.id = id
        self.title = title
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
        self.type = type
        self.attendees = attendees.map({ name in
            var attendee = Attendee(name: name)
            attendee.questions = self.getQuestions()
            return attendee
        })
        
        
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        theme = data.theme
        type = data.type
        schedule = data.schedule
    
    }
    
     func getQuestions() -> [Question] {
        switch self.type {
        case .standup:
            return [Question("What I did yesterday?"), Question("What I will do today?"), Question("What is blocking my progress?")]
        case .test1:
            return [Question("qn 1"), Question("qn 2"), Question("qn 3")]
        case .test2:
            return [Question("qn 4"), Question("qn 5"), Question("qn 6")]
        }
    }
    
    //    TO ALLOW BOTH CODABLE AND OBSERVABLE OBJECT FIX
        
//        enum CodingKeys: CodingKey {
//                case id
//                case title
//                case attendees
//                case theme
//                case type
//                case history
//            }

//            required init(from decoder: Decoder) throws {
//                let values = try decoder.container(keyedBy: CodingKeys.self)
//                
//                self.id = try values.decode(UUID.self, forKey: .id)
//                self.title = try values.decode(String.self, forKey: .title)
//                self.attendees = try values.decode([Attendee].self, forKey: .attendees)
//                self.theme = try values.decode(Theme.self, forKey: .theme)
//                self.type = try values.decode(Type.self, forKey: .type)
//                self.history = try values.decode([History].self, forKey: .history)
//            }
//
//            func encode(to encoder: Encoder) throws {
//                var values = encoder.container(keyedBy: CodingKeys.self)
//                
//                try values.encode(self.id, forKey: .id)
//                try values.encode(self.title, forKey: .title)
//                try values.encode(self.attendees, forKey: .attendees)
//                try values.encode(self.theme, forKey: .theme)
//                try values.encode(self.theme, forKey: .type)
//                try values.encode(self.history, forKey: .history)
//            }
    
}

extension Meeting {
    struct Attendee: Identifiable, Codable {
        var id: UUID
        var name: String
        //var image: String
        var questions: [Question] = []
//        var isAllQuestionsAnswered: Bool {
//            self.questions.allSatisfy { $0.isAnswered == true }
//        }
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
            //self.image = image
//            self.questions = questions
        }
        
    }
    
    struct Data {
        var title: String = ""
        var attendees: [Attendee] = []
        var lengthInMinutes: Double = 5
        var theme: Theme = .seafoam
        
        var type: Type = .standup
        // all with default values -> no need create init(...)
        var schedule: Date = .now
    }

    //compound data property
    var data: Data {
        Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), theme: theme, type: type, schedule: schedule)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        theme = data.theme
        
        type = data.type
        schedule = data.schedule
    }
    
}

extension Meeting {
    static let sampleData: [Meeting] =
    [
        Meeting(title: "Minatic", attendees: ["Pawan", "Nirat", "Ziyi"], lengthInMinutes: 10, theme: .buttercup, type: .standup),
        Meeting(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange, type: .test1),
        Meeting(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 5, theme: .poppy, type: .test2)
    ]
}
