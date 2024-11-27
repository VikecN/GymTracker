//
//  NewWorkoutDayView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct NewWorkoutDayView: View {
    
    @State var numberOfWorkoutDays: Int = 0
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var dayNumber = 1
    @State private var workoutPlan = ""
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Workout Name", text: $workoutPlan)
                
                Button("Add Day"){
                    let newDay = WorkoutDay(
                                    dayNumber: (numberOfWorkoutDays + dayNumber),
                                    workoutPlan: workoutPlan,
                                    exercises: [])
                    modelContext.insert(newDay)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(workoutPlan.isEmpty)
                .navigationTitle("New Workout Day")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewWorkoutDayView()
}
