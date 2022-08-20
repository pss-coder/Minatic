//
//  MeetingQuestionView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct MeetingQuestionView: View {
    @Binding var question: Question
    @State private var isTapped: Bool = false
    @State private var dropDownImage: String = "arrow.right.circle"
    
    let checkisAllAnswered: () -> Void
    
    var body: some View {
        VStack {
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
                Image(systemName: dropDownImage)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isTapped.toggle()
                            dropDownImage = isTapped ? "arrow.down.circle" : "arrow.right.circle"
                        }
                    }
                
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)))
            .foregroundColor(.white)
            
            if isTapped {
                Text("response here")
            }
            
        }
        
    }
}

struct MeetingQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingQuestionView(question: .constant(Question("Testing???")), checkisAllAnswered: {})
    }
}
