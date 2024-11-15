//
//  WorkoutDayView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct WorkoutDayView: View {
    
    @Environment(\.modelContext) var modelContext
    
    var workoutDay: WorkoutDay
    
    @State var addExercise: Bool = false
    @State var editExercise: Bool = false
    
    var body: some View {
        VStack {
            Text(workoutDay.workoutPlan)
            NavigationStack {
                Group {
                    if workoutDay.exercises.isEmpty {
                        ContentUnavailableView {
                            Label("No Exercises", systemImage: "dumbbell.fill")
                        } description: {
                            Text("Click on the 'Add Exercise'")
                        }
                    } else {
                        List {
                            ForEach(workoutDay.exercises.sorted { $0.order < $1.order }) { exercise in
                                HStack {
                                    Text(exercise.exercise.name)
                                    Spacer()
                                    Text("\(exercise.sets) | \(exercise.reps)")
                                }
                                
                            }
                            .onDelete { IndexSet in
                                IndexSet.forEach {
                                    modelContext.delete(workoutDay.exercises[$0]) }
                            }


                        }
                    }
                }
                .toolbar {
                    Button {
                        addExercise = true
                    } label: {
                        Text("Add Exercise")
                    }
                }
                .padding()
            }
            .sheet(isPresented: $addExercise) {
                AddExerciseToWorkingDayView(workoutDay: workoutDay).presentationDetents([.medium])
            }

        }
        
 
    }
}

#Preview {
    WorkoutDayView(workoutDay: WorkoutDay(dayNumber: 1, workoutPlan: "Chest & Biceps", isRestDay: false, exercises: []))
}
