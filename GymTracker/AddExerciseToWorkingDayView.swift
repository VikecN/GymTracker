//
//  AddExerciseToWorkingDayView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct AddExerciseToWorkingDayView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var exercises: [Exercise]
    
    var workoutDay: WorkoutDay
    
    @State private var exercise: Exercise? = nil
    @State private var sets = ""
    @State private var reps = ""
    

    
    var body: some View {
        Form {
            Picker("Exercise", selection: $exercise) {
                Text("Select Exercise").tag(nil as Exercise?)
                
                ForEach(exercises, id: \.id) { exercise in
                    Text(exercise.name).tag(exercise as Exercise?)
                }
            }
            
            TextField("Sets", text: $sets)
                .keyboardType(.numberPad)
            TextField("Reps", text: $reps)
                .keyboardType(.numberPad)
            
            Button(action: addExerciseToWorkoutDay) {
                            Text("Add Exercise")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(exercise == nil || sets.isEmpty || reps.isEmpty)
        }
        
    }
    private func addExerciseToWorkoutDay() {
            guard let exercise = exercise,
                  let sets = Int(sets),
                  let reps = Int(reps) else {
                return
            }
            
        let configureExercise = ConfigureWorkoutDay(exercise: exercise, sets: sets, reps: reps, order: exercises.count)
            
            workoutDay.exercises.append(configureExercise)
            
            do {
                try modelContext.save()
                print("Exercise successfully added to WorkoutDay")
            } catch {
                print("Failed to save workout day: \(error)")
            }
            
            self.exercise = nil
            self.sets = ""
            self.reps = ""
        }
}

#Preview {
    AddExerciseToWorkingDayView(workoutDay: WorkoutDay(dayNumber: 1, workoutPlan: "Chest & Biceps", isRestDay: false, exercises: []))
}
