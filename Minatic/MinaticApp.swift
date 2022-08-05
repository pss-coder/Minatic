//
//  MinaticApp.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//

import SwiftUI

@main
struct MinaticApp: App {
    @StateObject private var store = MeetingStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                
                HomeView(meetings: $store.meetings) {
                    Task {
                        do {
                            try await MeetingStore.save(meetings: store.meetings)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                        }
                    } // end of Task
                }
                
            } // end of navigationView
            
            .task {
                do {
                    store.meetings = try await MeetingStore.load()
                    if store.meetings.isEmpty {
                        store.meetings = Meeting.sampleData
                    }
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Minatic will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper) {
                store.meetings = Meeting.sampleData
            } content: { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            
        } // end of windowGroup
    }
}
