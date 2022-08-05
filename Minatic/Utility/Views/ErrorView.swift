//
//  ErrorView.swift
//  Scrumdinger
//
//  Created by Pawandeep Singh on 24/7/22.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("An error has occurred!")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                    .font(.headline)
                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)
                Spacer()
            } // end of VStack
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        //dismiss is a structure. You can call a structure like a function if it includes callAsFunction().
                        dismiss()
                        
                    }
                }
            }
        } //end of NavigationView
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
            case errorRequired
        
    }
    
    static var wrapper: ErrorWrapper {
            ErrorWrapper(error: SampleError.errorRequired,
                         guidance: "You can safely ignore this error.")
        
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: wrapper)
    }
}
