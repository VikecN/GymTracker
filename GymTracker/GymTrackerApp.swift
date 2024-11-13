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
    
    var body: some Scene {
        WindowGroup {
            TrackerView()
        }
        .modelContainer(for: WorkoutDay.self)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
