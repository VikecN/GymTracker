//
//  StartStopTrackingView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/18/24.
//

import SwiftUI

struct StartStopTrackingView: View {
    
    @Binding var isTracking: Bool
    
    var body: some View {
        if !isTracking {
            Button(action: {
                print("Start Workount!!!")
                isTracking.toggle()
            }) {
                ButtonTemplate(txtColor: Color.white,
                               bgColor: Color.green,
                               text: "Start",
                               iconName: "play.circle")
            }
        } else {
            Button(action: {
                print("Stop Workount!!!")
                isTracking.toggle()
            }) {
                ButtonTemplate(txtColor: Color.white,
                               bgColor: Color.red,
                               text: "Stop",
                               iconName: "stop.circle")
            }
        }
    }
}

#Preview {
    StartStopTrackingView(isTracking: .constant(true))
}
