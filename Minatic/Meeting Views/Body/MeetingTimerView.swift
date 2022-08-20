//
//  MeetingTimerView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct MeetingTimerView: View {
    let speakers: [MeetingTimer.Speaker]
    
    let theme: Theme
    
    let isRecording: Bool
    
    var transcription: String
    
    private var currentSpeaker: String {
//        current speaker is the first person on the list who hasn’t spoken. If there isn’t
//        a current speaker, the expression returns “Someone.”
        speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"
    }
    
//    private var currentSpeakerQuestions: [Question] {
//        speakers.first(where: { !$0.isCompleted })?.questions ?? []
//    }
    
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                VStack {
                    Text(currentSpeaker)
                        .font(.title)
                    Text("is speaking")
                    Image(systemName: isRecording ? "mic" : "mic.slash")
                        .font(.title)
                        .padding(.top)
                        .accessibilityLabel(isRecording ? "with transcription" : "without transcription" )
                    
                    Text("\(transcription)")
                }
                .accessibilityElement(children: .combine)
                .foregroundStyle(theme.accentColor)
            }
            .overlay {
                ForEach(speakers) { speaker in
                    if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                        SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                            .rotation(Angle(degrees: -90))
                            .stroke(theme.mainColor, lineWidth: 12)
                    }
                }
            } // end of overlay
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    static var questions: [Question] = [Question("What I did yesterday?"), Question("What I will do today?"), Question("What is blocking my progress?")]
    
    static var speakers: [MeetingTimer.Speaker] {
        [MeetingTimer.Speaker(name: "Bill", isCompleted: true),
         MeetingTimer.Speaker(name: "Cathy", isCompleted: false)]
        }
    
    
    static var previews: some View {
        MeetingTimerView(speakers: speakers, theme: .yellow, isRecording: true, transcription: "transcription here")
    }
}
