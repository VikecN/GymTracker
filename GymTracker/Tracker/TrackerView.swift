//
//  TrackerView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/13/24.
//

import SwiftUI

struct TrackerView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Button("Start Program") {
                
                }
                .frame(width: 350, height: 50)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(15)
                .padding()
            }
            .navigationTitle("Gym Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink {
                    ProgramView()
                } label: {
                    Image(systemName: "text.document")
                    
                }
                
            }
            
        }

    }
}

#Preview {
    TrackerView()
}
