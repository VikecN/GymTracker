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
    
    @Query(descriptor) private var lastWorkout: [WorkoutTracker] = []
    
    @State private var fetchNextExercises: WorkoutDay? = nil
    
    static var descriptor: FetchDescriptor<WorkoutTracker> = {
        
        var descriptor = FetchDescriptor<WorkoutTracker>(sortBy: [SortDescriptor(\.startDateTime, order: .reverse)])
        descriptor.fetchLimit = 1
        
        return descriptor
    }()
    
    var body: some View {
        NavigationStack {
            VStack {
                if (fetchNextExercises != nil) {
                    Text("Today's for workout:")
                    Text(fetchNextExercises!.workoutPlan)
                    
                    if (fetchNextExercises != nil && !fetchNextExercises!.exercises.isEmpty) {
                        List(fetchNextExercises!.exercises) { exercise in
                            Text(exercise.exercise.name)
                        }
                    }

                
                    Spacer()
                    NavigationLink {
                        StartTrackingView(workoutSession: fetchNextExercises!)
                    }label: {
                        if !lastWorkout.isEmpty && lastWorkout.first?.isCompleted == false {
                            ButtonTemplate(txtColor: Color.white, bgColor: Color.orange, text: "Continue Tracking")
                        } else {
                            ButtonTemplate(txtColor: Color.white, text: "Start Tracking", iconName: "play")
                        }
                        
                    }
                } else {
                    ContentUnavailableView {
                        Label("Workout Unavailable", systemImage: "exclamationmark.bubble")
                    } description: {
                        Text("Add days to the program. Go to the 'Program'")
                    }
                }

                    
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        StatisticsView()
                    } label: {
                        Text("Statistics")
                        
                    }
                }
            }
            .task {
                await loadExercises()
            }
            
        }

    }
    
    func loadExercises() async {
        
        var lastWorkoutDayNumber = 1
        let numberOfDays = try! modelContext.fetchCount(FetchDescriptor<WorkoutDay>())
        
        
        if let session = lastWorkout.first {
            if (!(numberOfDays == session.workoutDay.dayNumber) && (session.isCompleted == true)) {
                lastWorkoutDayNumber = session.workoutDay.dayNumber + 1
            }
            
        }
        
        let predicate = #Predicate<WorkoutDay> {
            $0.dayNumber == lastWorkoutDayNumber
        }
        
        var descriptor = FetchDescriptor<WorkoutDay>(predicate: predicate, sortBy: [SortDescriptor(\.dayNumber, order: .reverse)])
        descriptor.fetchLimit = 1
        
        fetchNextExercises = try! modelContext.fetch(descriptor).first
        
    }
    
}

#Preview {
    TrackerView()
        .modelContainer(for: WorkoutDay.self, inMemory: true)
}
