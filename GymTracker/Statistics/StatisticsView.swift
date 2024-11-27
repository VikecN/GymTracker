//
//  StatisticsView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/27/24.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    @Query var sessions: [WorkoutTracker]
    
    var body: some View {
        List {
            
            ForEach(Array(sessions.enumerated()), id: \.element.id) { index, session in
                StatisticeSessionView(session: session, counter: index)
            }
        }
    }
}

#Preview {
    StatisticsView()
}
