//
//  StatisticeSessionView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/27/24.
//

import SwiftUI

struct StatisticeSessionView: View {
    
    @State var session: WorkoutTracker
    
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                ColumnView(columnName: "Workout", value: "\(session.workoutDay.workoutPlan)", type: "text")
                ColumnView(columnName: "Started", value: "\(session.startDateTime.ISO8601Format())", type: "date")
                NavigationLink {
                    WorkoutDayStatisticsView(session: session)
                } label: {
                    EmptyView()
                }
                .padding()
            }

            
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
                VStack(alignment: .leading) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(value)
                        .font(.body)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                .frame(minHeight: 30, alignment: .top)
                .padding(.vertical, 5)
                
            case "toggle":
                VStack(alignment: .leading, spacing: 5) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Toggle(isOn: $toggleValue) {
                        EmptyView()
                    }.disabled(true)
                }
                .frame(minHeight: 50, alignment: .top)
                .padding(.vertical, 5)
                
            case "date":
                VStack(alignment: .leading, spacing: 5) {
                    Text(columnName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    DatePicker(value, selection: $dateValue, displayedComponents: [.date])
                        .labelsHidden()
                        .disabled(true)
                }
                .frame(minHeight: 50, alignment: .top)
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
