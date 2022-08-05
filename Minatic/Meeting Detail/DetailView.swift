//
//  DetailView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var meeting: Meeting
    
    @State private var isPresentingTypeInfoView = false
    
    var body: some View {
        List {
            Section(header:Text("Meeting Info")) {
                NavigationLink(destination: MeetingView(meeting: $meeting)) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(meeting.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(meeting.theme.name)
                        .padding(4)
                        .foregroundColor(meeting.theme.accentColor)
                        .background(meeting.theme.mainColor)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            } // end of Meeting Info Section
            
            Section(header: Text("Attendees")) {
                ForEach(meeting.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            } // end of Attendees Section
            
            
            Section(header: Text("Meeting Type")) {
                HStack {
                    Button {
                        //isPresentingTypeInfoView = true
                    } label: {
                        Label("Type", systemImage: "info.circle")
                            .popover(isPresented: $isPresentingTypeInfoView) {
                                ForEach(meeting.getQuestions()) { question in
                                    Text(question.question)
                                }
                            }
                    }
                    Spacer()
                    Text("\(meeting.type.name) Meeting")
                }

            } // end of Meeting Type Section
            
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
            }
            
        } // end of List
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(meeting: .constant(Meeting.sampleData[1]))
    }
}
