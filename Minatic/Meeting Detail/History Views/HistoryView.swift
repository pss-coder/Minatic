//
//  HistoryView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct HistoryView: View {
    let history: History
    
    @State private var isPresentingEmailFieldView = false // for model sheet view
    
    @State var email: String

    var body: some View {
//        ScrollView {
            
            VStack {
                Text("DATETIME")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                
                List {
                    Section(header: Text("Meeting Type")) {
                        HStack {
                            Button {
                              //  isShowingQuestions = true
                            } label: {
                                Label("Type", systemImage: "info.circle")
                            }
                            Spacer()
                            Text("Standup Meeting")
                        }
        
                    } // end of Meeting Type Section
                    
                    //TODO: FOR PERSON HAS THEIR OWN TRANSCRIPTION
                    // logic: everytime - question is checked, take transcription and save to corresponding question
                    Section(header: Text("Attendees")) {
                        ForEach(history.speakers) { speaker in
                            NavigationLink(destination: HistoryResponseView(attendeeName: speaker.name, questions: speaker.questions, fullTranscription: history.transcript ?? "no transcription done")) {
                                Text(speaker.name)
                            }
                            
                        }
                    } // end of Attendees Section
                    
                    
                } // end of List
                
                Button {
                    isPresentingEmailFieldView = true
                } label: {
                    Text("Send Email")
                        .font(.callout)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isPresentingEmailFieldView) {
                    VStack {
                        TextField("Enter email to send", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        
                        Button {
                            
                            Task {
                                    _ = await EmailService.sendEmail(email: email, completion: { data in
                                        Alert(title: Text("Email Sent"))
                                    })
                            }
                            
                        } label: {
                            Text("Confirm Send")
                        }
                    }
                }
                
                
            } // end of VStack
            
            
//            VStack(alignment: .leading) {
//                Divider()
//                    .padding(.bottom)
//                Text("Attendees")
//                    .font(.headline)
//                Text(history.attendeeString)
//                if let transcript = history.transcript {
//                    Text("Transcript")
//                        .font(.headline)
//                        .padding(.top)
//                    Text(transcript)
//                }
//            } // end of VStack
//        }
//        .navigationTitle(Text(history.date, style: .date))
//        .padding()
    }
}

extension History {
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: speakers.map { $0.name })
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var history: History {
        History(speakers: [MeetingTimer.Speaker(name: "Jon", isCompleted: true), MeetingTimer.Speaker(name: "Darla", isCompleted: true), MeetingTimer.Speaker(name: "Luis", isCompleted: true)], lengthInMinutes: 10, transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI...")
    }
    
    static var previews: some View {
        HistoryView(history: history, email: "pawandeepse@me.com")
    }
}
