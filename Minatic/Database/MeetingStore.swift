//
//  MeetingStore.swift
//  Minatic
//
//  Created by Pawandeep Singh on 4/8/22.
//


import Foundation
import SwiftUI

//ObservableObject is a class-constrained protocol
//for connecting external model data to SwiftUI views.
class MeetingStore: ObservableObject {
    
    //An ObservableObject includes an objectWillChange publisher that emits when one of its @Published
    //properties is about to change.
    // Any view observing an instance of MeetingStore will render again when the meetings value changes.
    @Published var meetings: [Meeting] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("meetings.data")
    }
    
    // async version of load() using async
    static func load() async throws -> [Meeting] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let meetings):
                    continuation.resume(returning: meetings)
                }
            }
        }
    }
    
    //Result is a single type that represents the outcome of an operation, whether it’s a success or
    //failure. The load function accepts a completion closure that it calls asynchronously with either an
    //array of meetings or an error.
    static func load(completion: @escaping (Result<[Meeting], Error>)->Void) {
        
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                
                // if running for 1st time -> return empty arry
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                } // end of guard
                
                // file load complete
                let loadedMeetings = try JSONDecoder().decode([Meeting].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedMeetings))
                }
            } catch {
                // Fail to load file
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    } // end of load()
    
    
    @discardableResult
    static func save(meetings: [Meeting]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(meetings: meetings) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let meetingsSaved):
                    continuation.resume(returning: meetingsSaved)
                    
                }
                
            }
        }
    }
    
    static func save(meetings: [Meeting], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            
            do {
                let data = try JSONEncoder().encode(meetings)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(meetings.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
    } // end of save()
}
