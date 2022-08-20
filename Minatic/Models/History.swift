//
//  History.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var speakers: [MeetingTimer.Speaker]
    var lengthInMinutes: Int
    var transcript: String?
    
    init(id: UUID = UUID(), date: Date = Date(), speakers: [MeetingTimer.Speaker], lengthInMinutes: Int = 5, transcript: String? = nil) {
        self.id = id
        self.date = date
        self.speakers = speakers
        self.lengthInMinutes = lengthInMinutes
        self.transcript = transcript
        
    }
}
