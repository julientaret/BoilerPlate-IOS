//
//  SplashLogoComponent.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct SplashLogoComponent: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    let animationCompleted: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .scaleEffect(scale)
                .opacity(opacity)
                .animation(.easeInOut(duration: 1.0), value: scale)
                .animation(.easeInOut(duration: 1.0), value: opacity)
            
            Text("Boilerplate")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(opacity)
                .animation(.easeInOut(duration: 1.0).delay(0.5), value: opacity)
            Text("Start building your app now!")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(.white)
        }
        .onAppear {
            withAnimation {
                scale = 1.2
                opacity = 1.0
            }
        }
    }
}
