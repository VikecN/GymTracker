//
//  TrackerView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI
import SwiftData

struct TrackerView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var lastWorkout: WorkoutTracker?
    @State private var nextWorkout: WorkoutDay?
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    if ((nextWorkout?.exercises.isEmpty) != false) {
                        ContentUnavailableView {
                            Label("Workout Unavailable", systemImage: "exclamationmark.bubble")
                        } description: {
                            Text("Add days to the program. Go to the 'Program'")
                        }
                        
                    } else {
                        Text("Today's for workout:")
                        Text(nextWorkout?.workoutPlan ?? "No Next")
                        
                        List(nextWorkout?.exercises ?? []) { workout in
                            Text(workout.exercise.name)
                        }
                    }
                }
 
                Spacer()
                StartWorkoutView()
            }
            .navigationTitle("Gym Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink {
                    ProgramView()
                } label: {
                    Text("Program")
                    
                }
                
            }
            
        }.task {
            print("Loading... Last Workout")
            await fetchLastWorkout()
            
            print("Loading... Next Workout")
            await fetchNextWorkout()
        }

    }
    
    func fetchLastWorkout() async {
        do {
            let request = FetchDescriptor<WorkoutTracker>(
                predicate: nil, sortBy: [SortDescriptor(\.id, order: .reverse)]
            )
            
            let result = try modelContext.fetch(request)
            
            if result == [] {
                lastWorkout = nil
            } else {
                lastWorkout = result.first
            }
            
        } catch {
            print("Failed to fetch last workout: \(error)")
        }
    }
    
    func fetchNextWorkout() async {
        do {
                // Fetch all workout days in ascending order of day number
                let workoutDayRequest = FetchDescriptor<WorkoutDay>(
                    sortBy: [SortDescriptor(\.dayNumber, order: .forward)]
                )
                let allWorkoutDays = try modelContext.fetch(workoutDayRequest)
                
                guard !allWorkoutDays.isEmpty else {
                    print("No workout days defined.")
                    nextWorkout = nil
                    return
                }
                
                // Determine the next workout day
                if let lastDayNumber = lastWorkout?.workoutDay.dayNumber {
                    if let currentIndex = allWorkoutDays.firstIndex(where: { $0.dayNumber == lastDayNumber }) {
                        let nextIndex = (currentIndex + 1) % allWorkoutDays.count
                        nextWorkout = allWorkoutDays[nextIndex]
                    }
                } else {
                    nextWorkout = allWorkoutDays.first
                }
            } catch {
                print("Failed to fetch next workout: \(error)")
            }
    }
    
}

#Preview {
    TrackerView()
        .modelContainer(for: WorkoutDay.self, inMemory: true)
}
