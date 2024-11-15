//
//  StartWorkoutView.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/14/24.
//

import SwiftUI

struct StartWorkoutView: View {
    
    @State var isStarted: Bool = false
    
    var body: some View {
        
        if isStarted {
            HStack {
                Button(action: {
                    print("Pause Workount!!!")
                }) {
                    ButtonTemplate(txtColor: Color.white,
                                   bgColor: Color.gray, 
                                   text: "Pause",
                                   iconName: "pause.circle"
                                    )
                }
                
                Button(action: {
                    isStarted = false
                    print("Stop Workount!!!")
                }) {
                    ButtonTemplate(txtColor: Color.white,
                                   bgColor: Color.red,
                                   text: "Stop",
                                   iconName: "stop.circle")
                }
            }
            
            } else {
            Button(action: {
                isStarted = true
                print("Start Workount!!!")
            }) {
                ButtonTemplate(txtColor: Color.white, text: "Start Workout", iconName: "play.circle")
            }
        }

        
    }
}

struct ButtonTemplate: View {
    
    var txtColor: Color = .white
    var bgColor: Color = .green
    var text: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(text)
        }            
        .foregroundStyle(txtColor)
        .font(.system(size: 20))
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(bgColor)
            )
        .padding()
    }
}

#Preview {
    StartWorkoutView()
}
