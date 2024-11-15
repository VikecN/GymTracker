//
//  ListAllExercisesView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct ListAllExercisesView: View {
    
    @State private var showAddExercise: Bool = false
    
    @Query var exercises: [Exercise]
    
    var body: some View {
        NavigationStack {
            Group {
                if exercises.isEmpty {
                    ContentUnavailableView {
                        Label("No Exercises", systemImage: "figure.run.square.stack.fill")
                    } description: {
                        Text("Add exercises on the icon, top rigth corner. ")
                    }
                }else {
                    List {
                        ForEach(exercises) { exercise in
                            Text(exercise.name)
                        }
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
}

#Preview {
    ListAllExercisesView()
}
