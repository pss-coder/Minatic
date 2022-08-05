//
//  MeetingView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var meeting: Meeting
    @StateObject var meetingTimer = MeetingTimer()
    
    // for sound completion
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    // for speech
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false // to display recording indicator
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(meeting.theme.mainColor)
            VStack {
                // Header
                MeetingHeaderView(secondsElapsed: meetingTimer.secondsElapsed, secondsRemaining: meetingTimer.secondsRemaining, theme: meeting.theme)
                
                //Placeholder for circular timer view
                MeetingTimerView(speakers: meetingTimer.speakers, theme: meeting.theme, isRecording: isRecording)
                
                ForEach($meetingTimer.questions) { question in
                    MeetingQuestionView(question: question) {
                        print(meetingTimer.isAllQuestionAnswered)
                        // logic here -> if is true -> set speaker isCompleted
                        // reset -> ticks
                        if meetingTimer.isAllQuestionAnswered {
                            // auto skip speaker
                            meetingTimer.skipSpeaker()
                        }
                    }
                }
                // when all questions are checked
                // skip to next speaker
                
                
                
                
                //Footer
                MeetingFooterView(speakers: meetingTimer.speakers, skipAction: meetingTimer.skipSpeaker)
                
            } // end of VStack
            
        } // end of ZStack
        .padding()
        .foregroundColor(meeting.theme.accentColor)
        .onAppear(perform: {
            
            //The timer resets each time an instance of MeetingView shows on screen,
            //indicating that a meeting should begin.
            meetingTimer.reset(lengthInMinutes: meeting.lengthInMinutes, attendees: meeting.attendees, questions: meeting.getQuestions())
            
            meetingTimer.speakerChangedAction = {
                player.seek(to: .zero)
                player.play()
            }
            
            speechRecognizer.reset() // ensure speech recognizer ready to start
            speechRecognizer.transcribe() // begins transcription
            isRecording = true
            
            meetingTimer.startScrum()
            
        })
        .onDisappear(perform: {
            meetingTimer.stopScrum()
            
            speechRecognizer.stopTranscribing();
            isRecording = false
            
            let newHistory = History(attendees: meeting.attendees, lengthInMinutes: meeting.timer.secondsElapsed / 60, transcript: speechRecognizer.transcript)
            meeting.history.insert(newHistory, at: 0)
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(meeting: .constant(Meeting.sampleData[0]))
    }
}
