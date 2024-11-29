//
//  ExerciseSetsDataInputView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/28/24.
//

import SwiftUI
import SwiftData

struct ExerciseSetsDataInputView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State var exerciseSetData: TrackingHistory? = nil
    
    @State var set: Int
    @State var exercise: Exercise
    @State var sessionID: UUID
    
    @State var reps: Int?
    @State var weight: Float?
    
    var body: some View {
        HStack {
            Text(String(set) + ".")
            TextField("Reps", value: $reps, format: .number)
                .keyboardType(.numberPad)
            TextField("Weight", value: $weight, format: .number)
                .keyboardType(.decimalPad)
        }.task {
            await fetchExerciseSetData()
            
            if (exerciseSetData != nil) {
                reps = exerciseSetData?.reps
                weight = exerciseSetData?.weight
            }
        }
    }
    
    private func fetchExerciseSetData() async {
        
        let descriptor = FetchDescriptor<TrackingHistory>(
            predicate: #Predicate<TrackingHistory> {
                $0.sessionID == sessionID &&
                $0.set == set
            }
        )
        do {
            exerciseSetData = try modelContext.fetch(descriptor).first
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

#Preview {
    ExerciseSetsDataInputView(set: 1, exercise: Exercise(name: "Bench Press"), sessionID: UUID())
}
