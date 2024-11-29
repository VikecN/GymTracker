//
//  Models.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftData
import Foundation

@Model
class WorkoutDay {
    var dayNumber: Int
    var workoutPlan: String
    var exercises: [ConfigureWorkoutDay] = []
    
    init(dayNumber: Int, workoutPlan: String, exercises: [ConfigureWorkoutDay]) {
        self.dayNumber = dayNumber
        self.workoutPlan = workoutPlan
        self.exercises = exercises
    }
}

@Model
class ConfigureWorkoutDay: Identifiable {
    var exercise: Exercise
    var sets: Int
    var reps: Int
    var order: Int
    
    init(exercise: Exercise, sets: Int, reps: Int, order: Int) {
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
        self.order = order
    }
}

@Model
class Exercise {
    var id: UUID = UUID()
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.name = name
    }
}


@Model
class WorkoutTracker {
    var sessionID: UUID = UUID()
    var startDateTime: Date = Date.now
    var endDateTime: Date? = nil
    var duration: TimeInterval? = nil
    var workoutDay: WorkoutDay
    var isCompleted: Bool = false
    
    init(workoutDay: WorkoutDay, endDateTime: Date?, isCompleted: Bool, duration: TimeInterval) {
        self.workoutDay = workoutDay
        self.endDateTime = endDateTime
        self.isCompleted = isCompleted
        self.duration = duration
    }
    
    init(workoutDay: WorkoutDay, isCompleted: Bool) {
        self.workoutDay = workoutDay
        self.isCompleted = isCompleted
    }
    
}

@Model
class TrackingHistory {
    var id: UUID = UUID()
    var sessionID: UUID
    @Relationship var exercise: Exercise
    var set: Int
    var reps: Int?
    var weight: Float?
    
    init(sessionID: UUID, exercise: Exercise, set: Int, reps: Int, weight: Float) {
        self.sessionID = sessionID
        self.exercise = exercise
        self.set = set
        self.reps = reps
        self.weight = weight
    }
}
