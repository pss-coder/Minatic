//
//  MeetingQuestionView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct MeetingQuestionView: View {
    @Binding var question: Question
    
    let checkisAllAnswered: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: question.isAnswered ? "checkmark.square" : "square")
                .onTapGesture {
                    question.isAnswered.toggle()
//                    + also check if allquestions are also answered???
                    checkisAllAnswered()
                }
            Spacer()
            Text("\(question.question)")
                .bold()
            Spacer()
            Image(systemName: "arrow.down.circle")
        }
        .padding()
    }
}

struct MeetingQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingQuestionView(question: .constant(Question("Testing???")), checkisAllAnswered: {})
    }
}
