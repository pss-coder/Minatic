//
//  MeetingFooterView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 19/7/22.
//

import SwiftUI

struct MeetingFooterView: View {
    let speakers: [MeetingTimer.Speaker]
    
    //to skip speaker
    var skipAction: () -> Void
    
    // to finishMeeting: () -> void
    var finishMeeting: () -> Void
    
    private var speakerNumber: Int? {
            guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil}
            return index + 1
    }
    
    private var isLastSpeaker: Bool {
        //This property is true if the isCompleted property of each speaker except the last speaker is true.
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }
    
    private var speakerText: String {
            guard let speakerNumber = speakerNumber else { return "No more speakers" }
            return "Speaker \(speakerNumber) of \(speakers.count)"
        }
    
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                    //TODO: ADD button to finish meeting
                    Button(action: finishMeeting) {
                        Text("Finish Meeting")
                    }
                    
                } else {
                    Text(speakerText)
                    Spacer()
                    Button(action: skipAction) {
                        Image(systemName: "forward.fill")
                    }
                    .accessibilityLabel("Next speaker")
                }
            } // end of HStack
        } // end of VStack
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingFooterView(speakers: Meeting.sampleData[0].attendees.speakers, skipAction: {}, finishMeeting: {})
            .previewLayout(.sizeThatFits)
    }
}
