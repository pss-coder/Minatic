//
//  CardView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

struct CardView: View {
    let meeting: Meeting
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(meeting.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Label("\(meeting.attendees.count)", systemImage: "person.3")
                    .accessibilityLabel("\(meeting.attendees.count) attendees")
                Spacer()
                Label("\(meeting.lengthInMinutes)", systemImage: "clock")
                    .accessibilityLabel("\(meeting.lengthInMinutes) minute meeting")
                    .labelStyle(.trailingIcon) // LabelStyle.Swift
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(meeting.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var meeting = Meeting.sampleData[0]
    static var previews: some View {
        CardView(meeting: meeting)
            .background(meeting.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
