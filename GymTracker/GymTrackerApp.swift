//
//  GymTrackerApp.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/12/24.
//

import SwiftUI
import SwiftData

@main
struct GymTrackerApp: App {
    
    let modelConatiner: ModelContainer = {
        let schema = Schema([WorkoutDay.self, ConfigureWorkoutDay.self, Exercise.self, WorkoutTracker.self])
        let configuration = ModelConfiguration("GymTracker")
        
        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Container not initialized!")
        }
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            TrackerView()
        }
        .modelContainer(modelConatiner)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
