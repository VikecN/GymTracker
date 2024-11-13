//
//  AddExerciseView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct AddExerciseView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var exerciseName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Exercise Name", text: $exerciseName)
                Button("Add Exercise") {
                    let exercise = Exercise(name: exerciseName)
                    modelContext.insert(exercise)
                    dismiss()
                }.frame(maxWidth: .infinity)
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

#Preview {
    AddExerciseView()
}
