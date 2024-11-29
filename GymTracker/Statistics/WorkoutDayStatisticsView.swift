//
//  WorkoutDayStatisticsView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/27/24.
//

import SwiftUI

struct WorkoutDayStatisticsView: View {
    
    @State private var currentTime = Date()
    
    @State var session: WorkoutTracker
    
    var body: some View {
        Grid {
            GridRow(alignment: .top) {
                Text("SessionID")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(session.sessionID.uuidString)
                    .font(.body)
            }
            .frame(minWidth: 150, minHeight: 50)
            
            GridRow(alignment: .top) {
                Text("Start Date Time")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                DatePicker("", selection: .constant(session.startDateTime), displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .disabled(true)
                
            }
            .frame(minWidth: 150, minHeight: 50)
            
            GridRow(alignment: .top) {
                Text("End Date Time")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if session.endDateTime != nil {
                    DatePicker("", selection: .constant(session.endDateTime!), displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .disabled(true)
                }
            }
            .frame(minWidth: 150, minHeight: 50)
            
            GridRow(alignment: .top) {
                Text("Workount Duration")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if !session.isCompleted {
                    Text(calculateDuration())
                        .font(.headline)
                        .foregroundColor(.blue)
                        .onAppear(perform: startTimer)
                } else {
                    Text(formatDuration(session.duration) ?? "")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
            }
            .frame(minWidth: 150, minHeight: 50)
            
            GridRow(alignment: .top) {
                Text("Finished")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(session.isCompleted ? "Yes" : "No")
            }
            .frame(minWidth: 150, minHeight: 50)
        }
        .padding()
    
    }
    
    func formatDuration(_ duration: TimeInterval?) -> String? {
        guard let duration = duration else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: duration)
    }
    
    func calculateDuration() -> String {
        let elapsed = currentTime.timeIntervalSince(session.startDateTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.currentTime = Date()
            // Stop timer if workout is completed (optional safeguard)
            if session.isCompleted {
                timer.invalidate()
            }
        }
    }
}

#Preview {
//    WorkoutDayStatisticsView(session: .constant(WorkoutTracker(workoutDay: WorkoutDay(dayNumber: 1, workoutPlan: "Chest", exercises: [ConfigureWorkoutDay(exercise: Exercise(name: "Bench"), sets: 1, reps: 2, order: 1)]), isCompleted: false)))
}
