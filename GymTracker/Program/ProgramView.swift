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
                    ContentUnavailableView {
                        Label("Add Your workout sessions", systemImage: "plus.square.on.square")
                    } description: {
                        Text("Add days to the icon on the top right corner, but first go to 'View Exercises'")
                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button{
                    addNewWorkingDay = true
                } label: {
                    Image(systemName: "plus.square.on.square")
                }
            }
            .sheet(isPresented: $addNewWorkingDay) {
                NewWorkoutDayView(numberOfWorkoutDays: workouts.count)
                    .presentationDetents([.medium])
            }
            NavigationLink {
                ListAllExercisesView()
                    .navigationBarTitle("All Exercises")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("View Exercises")
                Image(systemName: "square.grid.3x3")
            }
        }
        

    }
}

#Preview {
    ProgramView()
        .modelContainer(for: WorkoutDay.self, inMemory: true)
}
