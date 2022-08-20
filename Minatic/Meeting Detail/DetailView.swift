//
//  DetailView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var meeting: Meeting
    
    @State private var data = Meeting.Data()
    @State private var isPresentingEditView = false // for model sheet view
    
    @State private var isShowingQuestions = false
    
    @State private var isMeetingStarted = false
    
    
    var body: some View {
        VStack {
            Text("Minatic")
                .font(.largeTitle)
                .bold()
                .padding()
            HStack {
                Label("\(meeting.schedule.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar")
                    .font(.caption)
                Spacer()
                Label("\(meeting.schedule.formatted(date: .omitted, time: .shortened))", systemImage: "clock")
                    .font(.caption)
            }
            .padding()
            
            List {
                
                Section(header: Text("Meeting Type")) {
                    HStack {
                        Button {
                            isShowingQuestions = true
                        } label: {
                            Label("Type", systemImage: "info.circle")
                                .popover(isPresented: $isShowingQuestions) {
                                    ForEach(meeting.getQuestions()) { question in
                                        Text(question.question)
                                    }
                                }
                        }
                        Spacer()
                        Text("\(meeting.type.name) Meeting")
                    }
    
                } // end of Meeting Type Section
                
                
                Section(header: Text("Attendees")) {
                    ForEach(meeting.attendees) { attendee in
                        Label(attendee.name, systemImage: "person")
                    }
                } // end of Attendees Section
                
                Section(header: Text("History")) {
                    if meeting.history.isEmpty {
                        Label("No Meetings yet", systemImage: "calendar.badge.exclamationmark")
                    }
                    ForEach(meeting.history) { history in
                        NavigationLink(destination: HistoryView(history: history)) {
                            HStack {
                                Image(systemName: "calendar")
                                Text(history.date, style: .date)
                            }
                        }
                    } // end of forEach
                } // end of History Section
                
                
            } // end of List
            
            // ACCORDIAN ANSWER HERE !!!!
            //.listStyle(.sidebar)
            
            
            
            Button {
                
            } label: {
                NavigationLink(destination: MeetingView(meeting: $meeting), isActive: $isMeetingStarted) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.blue)
                }.onTapGesture {
                    isMeetingStarted = true
                }
            }
            
            Spacer(minLength: 15)

        } // end of VStack
        .navigationTitle(meeting.title)
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
                data = meeting.data
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView(data: $data)
                    .navigationTitle(meeting.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        } // End of Cancellation ToolBar Item
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                print(data.attendees)
                                meeting.update(from: data)
                            }
                        }// End of Confirmation ToolBar Item
                    }
            }
        } // end of .sheet
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(meeting: .constant(Meeting.sampleData[1]))
    }
}
