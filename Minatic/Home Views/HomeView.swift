//
//  ContentView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var meetings: [Meeting]
    @State private var isPresentingNewMeetingView = false
    @State private var newMeetingData = Meeting.Data()
    
    let saveAction: () -> Void
    
    var body: some View {
        
        List {
            ForEach($meetings) { $meeting in
                NavigationLink(destination: DetailView(meeting: $meeting)) {
                    CardView(meeting: meeting)
                }
                .listRowBackground(meeting.theme.mainColor)
                
            }
        } // end of List
        .navigationTitle("Meetings")
        .toolbar {
            Button(action: {
                isPresentingNewMeetingView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        } // end of .toolbar
        .sheet(isPresented: $isPresentingNewMeetingView) {
            NavigationView {
                DetailEditView(data: $newMeetingData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewMeetingView = false
                                newMeetingData = Meeting.Data()
                            }
                        } // end of Cancellation ToolBarItem
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newMeeting = Meeting(data: newMeetingData)
                                meetings.append(newMeeting)
                                isPresentingNewMeetingView = false
                                newMeetingData = Meeting.Data()
                            }
                        } // end of ToolBarItem
                    }
            } // end of NavigationView{}
        } // end of NewMeetingView Sheet
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(meetings: .constant(Meeting.sampleData), saveAction: {})
    }
}
