//
//  SplashModel.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import Foundation

class SplashModel: ObservableObject {
    @Published var isLoading = true
    @Published var animationCompleted = false
    
    private let minimumSplashDuration: TimeInterval = 2.0
    
    func startSplashSequence() {
        Task {
            await MainActor.run {
                animationCompleted = false
            }
            
            try? await Task.sleep(nanoseconds: UInt64(minimumSplashDuration * 1_000_000_000))
            
            await MainActor.run {
                animationCompleted = true
                isLoading = false
            }
        }
    }
}