//
//  DetailEditView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 5/8/22.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var data: Meeting.Data
    
    // Source of truth
    // private -> only accessed within view they are created in
    @State private var newAttendeeName = ""
    @State private var isShowingQuestions = false
    
    var body: some View {
        Form {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $data.title)
                HStack {
                    Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                    Spacer()
                    Text("\(Int(data.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                
                DatePicker("Schedule", selection: $data.schedule, in: Date.now...)
                
                ThemePicker(selection: $data.theme)
                
            } // end of Meeting Info Section
            
            Section(header: Text("Attendees")) {
                ForEach(data.attendees) { attendee in
                    Text(attendee.name)
                }
                .onDelete { Indices in
                    data.attendees.remove(atOffsets: Indices)
                }
                HStack {
                    TextField("New Attendee", text: $newAttendeeName)
                    Button(action: {
                        withAnimation {
                            let attendee = Meeting.Attendee(name: newAttendeeName)
                            data.attendees.append(attendee)
                            newAttendeeName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newAttendeeName.isEmpty) //btn disabled only when field is empty
                }
            } // end of Attendees Section
            
            Section(header: Text("Meeting Type")) {
                HStack {
                    Button {
                        isShowingQuestions.toggle()
                    } label: {
                        Label("Type", systemImage: "info.circle")
                    }
                    .sheet(isPresented: $isShowingQuestions) {
                        QuestionView()
                    }
                    Spacer()
                    Text("Standup Meeting")
                }

            } // end of Meeting Type Section
            
        } // end of Form
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(Meeting.sampleData[0].data))
    }
}
