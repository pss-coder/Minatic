//
//  HistoryResponseView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 11/8/22.
//

import SwiftUI

struct HistoryResponseView: View {
    let attendeeName: String
    var questions: [Question]
    let fullTranscription: String
    
    var body: some View {
        VStack {
            Text(attendeeName)
            Text(fullTranscription)
            ForEach(questions) { question in
                Text("\(question.question), answer: \(question.response)")
            }
        }
    }
}

struct HistoryResponseView_Previews: PreviewProvider {
    static var previews: some View {
        let questions: [Question] = [Question("What I did yesterday?", isAnswered: true, response: "JUST CODING LORH"), Question("What I will do today?", isAnswered: true, response: "more coding"), Question("What is blocking my progress?", isAnswered: true, response: "Coding")]
        HistoryResponseView(attendeeName: "Pawan", questions: questions, fullTranscription: "full transcription here")
    }
}
