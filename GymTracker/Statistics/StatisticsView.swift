//
//  StatisticsView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/27/24.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    @Query(descriptor()) var sessions: [WorkoutTracker]
    
    static private func descriptor() -> FetchDescriptor<WorkoutTracker> {
        var descriptor = FetchDescriptor<WorkoutTracker>(sortBy: [SortDescriptor(\.startDateTime, order: .reverse)])
        descriptor.fetchLimit = 3
        
        return descriptor
    }
    
    var body: some View {
        Text("Last 3 Sessions")
        List {
            ForEach(sessions) { session in
                StatisticeSessionView(session: session)
            }
            NavigationLink {
                
            } label: {
                Text("View All")
            }
        }
    }
}

#Preview {
    StatisticsView()
}
