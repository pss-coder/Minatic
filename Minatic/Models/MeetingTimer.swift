/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.
class MeetingTimer: ObservableObject {
    /// A struct to keep track of meeting attendees during a meeting.
    struct Speaker: Identifiable, Codable {
        /// The attendee name.
        let name: String
        /// True if the attendee has completed their turn to speak.
        var isCompleted: Bool
        /// Id for Identifiable conformance.
        var id = UUID()
        
        var questions: [Question] = []
    }
    
    /// The name of the meeting attendee who is speaking.
    @Published var activeSpeaker = ""
    /// The number of seconds since the beginning of the meeting.
    @Published var secondsElapsed = 0
    /// The number of seconds until all attendees have had a turn to speak.
    @Published var secondsRemaining = 0
    /// All meeting attendees, listed in the order they will speak.
    @Published private(set) var speakers: [Speaker] = []
    // The index of the meeting attendee who is speaking
    @Published var speakerIndex: Int = 0
    
    
    
    // Questions for speakers during meeting
    @Published var questions: [Question] = []

    /// The scrum meeting length.
    private(set) var lengthInMinutes: Int
    /// A closure that is executed when a new attendee begins speaking.
    var speakerChangedAction: (() -> Void)?

    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    private var secondsPerSpeaker: Int {
        (lengthInMinutes * 60) / speakers.count
    }
    private var secondsElapsedForSpeaker: Int = 0
    
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?
    
    var isAllQuestionAnswered: Bool {
        self.questions.allSatisfy { $0.isAnswered == true }
    }
    
    /**
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer.
     
     - Parameters:
        - lengthInMinutes: The meeting length.
        -  attendees: A list of attendees for the meeting.
     */
    init(lengthInMinutes: Int = 0, attendees: [Meeting.Attendee] = [], questions: [Question] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        
        self.questions = questions
        
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    /// Start the timer.
    func startScrum() {
        changeToSpeaker(at: 0)
    }
    
    /// Stop the timer.
    func stopScrum() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }
    
    /// Advance the timer to the next speaker.
    func skipSpeaker() {
        // Update speaker response to respective questions
        speakers[speakerIndex].questions = questions
        
        
        changeToSpeaker(at: speakerIndex + 1)
        
        //NEWLY ADDED FOR QUESTIONS
        resetQuestions()
    }
    

    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText

        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
    }

    private func update(secondsElapsed: Int) {
        secondsElapsedForSpeaker = secondsElapsed
        self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
        guard secondsElapsed <= secondsPerSpeaker else {
            return
        }
        secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)

        guard !timerStopped else { return }

        if secondsElapsedForSpeaker >= secondsPerSpeaker {
            changeToSpeaker(at: speakerIndex + 1)
            speakerChangedAction?()
        }
    }
    
    /**
     Reset the timer with a new meeting length and new attendees.
     
     - Parameters:
         - lengthInMinutes: The meeting length.
         - attendees: The name of each attendee.
     */
    func reset(lengthInMinutes: Int, attendees: [Meeting.Attendee], questions: [Question]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        
        self.questions = questions
        
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    private func resetQuestions() {
        for question in questions {
            question.isAnswered = false
        }
    }
}

extension Meeting {
    /// A new `MeetingTimer` using the meeting length and attendees in the `Meeting`.
    var timer: MeetingTimer {
        MeetingTimer(lengthInMinutes: lengthInMinutes, attendees: attendees, questions: getQuestions())
    }
}

extension Array where Element == Meeting.Attendee {
    var speakers: [MeetingTimer.Speaker] {
        if isEmpty {
            return [MeetingTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            return map { MeetingTimer.Speaker(name: $0.name, isCompleted: false) }
        }
    }
}
