//
//  SplashView.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var model = SplashModel()
    
    var body: some View {
        ZStack {
            UIBackground.sunsetGlowRadial
            
            SplashLogoComponent(animationCompleted: model.animationCompleted)
        }
        .onAppear {
            model.startSplashSequence()
        }
    }
}

#Preview {
    SplashView()
}
