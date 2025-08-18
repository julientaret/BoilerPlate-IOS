//
//  BoilerplateApp.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

@main
struct BoilerplateApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if coordinator.showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                coordinator.dismissSplash()
            }
        }
    }
}
