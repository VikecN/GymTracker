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
    var isRestDay: Bool = false
    var exercises: [ConfigureWorkoutDay] = []
    
    init(dayNumber: Int, workoutPlan: String, isRestDay: Bool, exercises: [ConfigureWorkoutDay]) {
        self.dayNumber = dayNumber
        self.workoutPlan = workoutPlan
        self.isRestDay = isRestDay
        self.exercises = exercises
    }
}

@Model
class ConfigureWorkoutDay {
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
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
