//
//  NewWorkoutDayView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI

struct NewWorkoutDayView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var dayNumber = ""
    @State private var workoutPlan = ""
    @State private var isRestDay = false
    var body: some View {
        NavigationStack {
            Form {
                TextField("Day Number", text: $dayNumber).keyboardType(.numberPad)
                
                TextField("Workout Plan", text: $workoutPlan)
                
                Toggle("Rest Day", isOn: $isRestDay)
                
                Button("Add Day"){
                    let newDay = WorkoutDay(
                                    dayNumber: Int(dayNumber)!,
                                    workoutPlan: workoutPlan,
                                    isRestDay: isRestDay,
                                    exercises: [])
                    modelContext.insert(newDay)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(dayNumber.isEmpty || (workoutPlan.isEmpty && !isRestDay))
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
