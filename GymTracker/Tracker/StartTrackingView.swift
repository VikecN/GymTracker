//
//  StartTrackingView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/15/24.
//


import SwiftUI
import SwiftData

struct StartTrackingView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(descriptorWorkoutTracking()) var workoutTracking: [WorkoutTracker]
    
    @State private var currentTime = Date()
    @State var workoutSession: WorkoutDay
    @State var isTracking: Bool = false
    @State var currentExerciseIndex: Int = 0
    
    @State var nextButtonDisabled = false
    @State var previousButtonDisabled = true
    
    static private func descriptorWorkoutTracking() -> FetchDescriptor<WorkoutTracker> {
        print("--INFO:  StartTrackingView   ->      Fetched Active Session Data")
        let predicate = #Predicate<WorkoutTracker> {
            $0.isCompleted == false
        }
        
        var descriptor = FetchDescriptor<WorkoutTracker>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        return descriptor
    }
    
    var body: some View {
            VStack {
                if let session = workoutTracking.first {
                Grid {
                    GridRow {
                        Text("Exercise")
                        Text("Sets")
                        Text("Reps")
                    }.padding(.horizontal)
                    GridRow {
                        Text(workoutSession.exercises[currentExerciseIndex].exercise.name)
                        Text(String((workoutSession.exercises[currentExerciseIndex].sets)))
                        Text(String((workoutSession.exercises[currentExerciseIndex].reps)))
                    }.padding(.horizontal)
                    
                }
                
                List {
                    ForEach(Array(1...workoutSession.exercises[currentExerciseIndex].sets), id: \.self) { set in
                        ExerciseSetsDataInputView(set: set,
                                                  exercise: workoutSession.exercises[currentExerciseIndex].exercise, sessionID: session.sessionID)
                    }
                }

                Text(calculateDuration(startTime: session.startDateTime))
                    .font(.headline)
                    .foregroundColor(.blue)
                    .onAppear(perform: startTimer)
                
                HStack {
                    Button {
                        navigateExercisesBack()
                    } label: {
                        ButtonTemplate(bgColor: (!previousButtonDisabled ? Color.green : Color.gray), text: "< Previous")
                    }
                    .disabled(previousButtonDisabled)
                    Button {
                        navigateExercisesForeward()
                    } label: {
                        ButtonTemplate(bgColor: (!nextButtonDisabled ? Color.green : Color.gray),text: "Next >")
                    }
                    .disabled(nextButtonDisabled)
                }
            } else {
                Text("No Active Session!")
            }
            }.task {
                await startSessionIfNotStarted()
            }

        
            Spacer()
            Button {
                dismiss()
                stopSession()
            } label: {
                ButtonTemplate(txtColor: Color.white, bgColor: Color.red, text: "Stop Tracking", iconName: "stop")
            }
        
        
    }
    
    func navigateExercisesBack() {
        if (currentExerciseIndex > 0) {
            print("--INFO:  StartTrackingView   ->      Navigate to Previous Excersise")
            nextButtonDisabled = false
            currentExerciseIndex = currentExerciseIndex - 1
        } else {
            previousButtonDisabled = true
        }
    }
    
    func navigateExercisesForeward() {
        if (currentExerciseIndex < workoutSession.exercises.count - 1) {
            print("--INFO:  StartTrackingView   ->      Navigate to Next Excersise")
            previousButtonDisabled = false
            currentExerciseIndex = currentExerciseIndex + 1
        } else {
            nextButtonDisabled = true
        }
    }
    
    func startSessionIfNotStarted() async {
        
        if !workoutTracking.isEmpty {
            isTracking = true
        } else {
            let session = WorkoutTracker(workoutDay: workoutSession, isCompleted: false)
            
            modelContext.insert(session)
            print("--INFO:  StartTrackingView   ->      Started New Session")
            
            do {
                try modelContext.save()
                isTracking = true
            } catch {
                print("--ERROR:  StartTrackingView   ->      There has been an problem with starting the seesion: -> \(error)")
            }
        }
    }
    
    func stopSession() {
        do {
            for session in workoutTracking {
                let endTime = Date.now
                session.isCompleted = true
                session.endDateTime = endTime
                session.duration = calcTime(startTime: session.startDateTime, endTime: endTime)
            }
            
            try modelContext.save()
            print("--INFO:  StartTrackingView   ->      Session Completed")
        } catch {
            print("--ERROR:  StartTrackingView   ->      Error ocured in stoping the session. Error -> \(error.localizedDescription)")
        }

    }
    
    func calcTime(startTime: Date, endTime: Date) -> TimeInterval{
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    }
    
    func calculateDuration(startTime: Date) -> String {
        
        let elapsed = currentTime.timeIntervalSince(startTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.currentTime = Date()
        }
    }
}



#Preview {
    let workoutSession = WorkoutDay(dayNumber: 1, workoutPlan: "Chest", exercises: [ConfigureWorkoutDay(exercise: Exercise(name: "Bench Press"), sets: 4, reps: 12, order: 1),ConfigureWorkoutDay(exercise: Exercise(name: "Lat Pulldown"), sets: 2, reps: 12, order: 1)] )
    StartTrackingView(workoutSession: workoutSession)
}
