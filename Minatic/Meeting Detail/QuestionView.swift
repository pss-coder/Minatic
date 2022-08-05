//
//  QuestionView.swift
//  Minatic
//
//  Created by Pawandeep Singh on 5/8/22.
//

import SwiftUI

struct QuestionView: View {
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack {
                Text("Questions display here")
            } // end of VStack
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            } // end of toolbar
        } // end of NavigationView
        
        
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
