//
//  ContentView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/12/24.
//

import SwiftUI
import SwiftData

struct ProgramView: View {
    
    @Query(sort: \WorkoutDay.dayNumber) private var workouts: [WorkoutDay]
    
    @State var addNewWorkingDay: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if workouts.isEmpty {
                    ContentUnavailableView("Add Your working sessions.", systemImage: "figure.run.square.stack.fill")
                } else {
                    List {
                        ForEach(workouts) { workout in
                            NavigationLink {
                                WorkoutDayView(workoutDay: workout)
                                    .navigationTitle("Day \(workout.dayNumber)")
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("Day \(workout.dayNumber)").font(.headline)
                                    
                                    if(workout.isRestDay) {
                                        Text("Rest Day").font(.subheadline)
                                    } else {
                                        Text("\(workout.workoutPlan)").font(.subheadline)
                                    }

                                }
                                Spacer()
                            }
                            
                        }
                    }

                }
            }                    
            .listStyle(.plain)
            .padding()
            .navigationTitle("Program")
            .toolbar {
                Button{
                    addNewWorkingDay = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .sheet(isPresented: $addNewWorkingDay) {
                NewWorkoutDayView()
                    .presentationDetents([.medium])
            }
            NavigationLink {
                ListAllExercisesView()
                    .navigationBarTitle("All Exercises")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("View Exercises")
            }
        }
        

    }
}

#Preview {
    ProgramView()
        .modelContainer(for: WorkoutDay.self, inMemory: true)
}
