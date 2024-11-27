//
//  StatisticeSessionView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/27/24.
//

import SwiftUI

struct StatisticeSessionView: View {
    
    @State var session: WorkoutTracker
    @State var counter: Int
    
    var body: some View {
        HStack {
            ColumnView(columnName: "No:", value: "\(counter)", type: "text")
            ColumnView(columnName: "Workout", value: "\(session.workoutDay.workoutPlan)", type: "text")
            ColumnView(columnName: "StartedOn", value: "\(session.startDateTime.ISO8601Format())", type: "date")
            ColumnView(columnName: "Status", value: "\(session.isCompleted)", type: "toggle")
            
        }
    }
    
    struct ColumnView: View {
        
        var columnName: String
        var value: String
        var type: String
        
        @State private var toggleValue: Bool
        @State private var dateValue: Date
        
        init(columnName: String, value: String, type: String) {
            self.columnName = columnName
            self.value = value
            self.type = type
            
            _toggleValue = State(initialValue: value.lowercased() == "true")
            
            _dateValue = State(initialValue: DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none) == value ? Date() : Date())
        }
        
        var body: some View {
            switch type {
            case "text":
                VStack(alignment: .leading, spacing: 5) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(value)
                        .font(.body)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                .padding(.vertical, 5)
                
            case "toggle":
                VStack(alignment: .leading, spacing: 5) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Toggle(isOn: $toggleValue) {
                        EmptyView()
                    }
                }
                .padding(.vertical, 5)
                
            case "button":
                VStack(alignment: .leading, spacing: 5) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button(action: {
                        print("\(columnName) button tapped")
                    }) {
                        Text(value)
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical, 5)
                
            case "date":
                VStack(alignment: .leading, spacing: 5) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    DatePicker(value, selection: $dateValue, displayedComponents: [.date])
                        .labelsHidden()
                }
                .padding(.vertical, 5)
                
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
//    StatisticeSessionView()
}
