//
//  ListAllExercisesView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct ListAllExercisesView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var showAddExercise: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Query var exercises: [Exercise]
    @Query var usedExercises: [ConfigureWorkoutDay]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises) { exercise in
                    Text(exercise.name)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        
                        let exerciseUsed = canDeleteExercise(exercis: exercises[index])
                        
                        if !exerciseUsed {
                            modelContext.delete(exercises[index])
                            try! modelContext.save()
                        } else {
                            alertMessage = "This exercise has been used in some part of the program. You cannot delete exercise that is in use. First make sure that is not used, after that you can delete it."
                            showAlert = true
                        }
                        
                    }
                    
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Cannot delete exercise"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .overlay {
                if exercises.isEmpty {
                    ContentUnavailableView {
                        Label("No Exercises", systemImage: "figure.run.square.stack.fill")
                    } description: {
                        Text("Add exercises on the icon, top rigth corner. ")
                    }
                }
            }
            .toolbar {
                Button {
                    showAddExercise = true
                } label: {
                    Image(systemName: "figure.run.square.stack")
                }
            }
        }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView()
                .presentationDetents([.medium])
        }

    }
    
    func canDeleteExercise(exercis: Exercise) -> Bool {
        do {
            let usedExercise = try modelContext.fetch(FetchDescriptor<ConfigureWorkoutDay>())
            return usedExercise.contains(where: {$0.exercise.name == exercis.name})
        } catch {
            print("Error fetching exercise usage: \(error)")
            return false
        }
            
    }
    
}

#Preview {
    ListAllExercisesView()
}
