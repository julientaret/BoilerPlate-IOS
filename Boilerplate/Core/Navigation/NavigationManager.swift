//
//  NavigationManager.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var selectedTab: TabItem = .home
    @Published var navigationPath = NavigationPath()
    
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
    }
    
    func resetToRoot() {
        navigationPath = NavigationPath()
    }
    
    func navigateToRoot(for tab: TabItem) {
        selectedTab = tab
        navigationPath = NavigationPath()
    }
}