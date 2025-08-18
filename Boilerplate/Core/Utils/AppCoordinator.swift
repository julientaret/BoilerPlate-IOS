//
//  AppCoordinator.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import Foundation
import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var showSplash = true
    
    func dismissSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplash = false
            }
        }
    }
}