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
    
    @State var workoutSession: WorkoutDay
    @State var isTracking: Bool = false
    @State var currentExerciseIndex: Int = 0
    
    var body: some View {
        
            VStack {
                Group {
                    Text(workoutSession.exercises[currentExerciseIndex].exercise.name)
                    Text("Sets: " + String((workoutSession.exercises[currentExerciseIndex].sets)))
                    Text("Reps: " + String((workoutSession.exercises[currentExerciseIndex].reps)))
                }
                List {
                    HStack {
                        Text(String(1) + ".")
                        TextField("Reps", text: .constant("")).keyboardType(.numberPad)
                        TextField("Weight", text: .constant("")).keyboardType(.numberPad)
                    }
                }
            }.task {
                await startSessionIfNotStarted()
            }

        
        Spacer()
        Button {
            stopSession()
            dismiss()
        } label: {
            ButtonTemplate(txtColor: Color.white, bgColor: Color.red, text: "Stop Tracking", iconName: "stop")
        }
        
    }
    
    func startSessionIfNotStarted() async {
        
        let checkStatusDB = checkInDbForActiveSessions()
        
        
        if checkStatusDB {
            isTracking = true
        } else {
            let session = WorkoutTracker(workoutDay: workoutSession, isCompleted: false)
            
            modelContext.insert(session)
            print("Started New Session!")
            
            do {
                try modelContext.save()
                isTracking = true
            } catch {
                print("There has been an problem with starting the seesion: ----> \(error)")
            }
        }
    }
    
    func checkInDbForActiveSessions() -> Bool {
        let predicate = #Predicate<WorkoutTracker> {
            $0.isCompleted == false
        }
        
        var descriptor = FetchDescriptor<WorkoutTracker>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        let sessionStatus = try! modelContext.fetch(descriptor)
        
        return !sessionStatus.isEmpty
    }
    
    func stopSession() {
        let predicate = #Predicate<WorkoutTracker>{
            $0.isCompleted == false
        }
        
        let startedSessionDescriptor = FetchDescriptor<WorkoutTracker>(predicate: predicate)

        do {
            let startedSession = try modelContext.fetch(startedSessionDescriptor)
            
            for session in startedSession {
                session.isCompleted = true
            }
            
            try modelContext.save()
            print("Session Completed")
        } catch {
            print("Error ocured in stoping the session. Error ---> \(error.localizedDescription)")
        }

    }
}



#Preview {
    let workoutSession = WorkoutDay(dayNumber: 1, workoutPlan: "Chest", exercises: [ConfigureWorkoutDay(exercise: Exercise(name: "Bench Press"), sets: 1, reps: 12, order: 1)] )
    StartTrackingView(workoutSession: workoutSession)
}
