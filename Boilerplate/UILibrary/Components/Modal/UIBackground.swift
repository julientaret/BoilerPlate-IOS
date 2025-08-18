//
//  UIBackground.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Available background type
/// - solid: Couleur unie
/// - gradient: Linear gradient
/// - radialGradient: Radial gradient
/// - image: Background image
enum UIBackgroundType {
    case solid(Color)
    case gradient(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing)
    case radialGradient(colors: [Color], center: UnitPoint = .center, startRadius: CGFloat = 0, endRadius: CGFloat = 300)
    case image(String, contentMode: ContentMode = .fill)
}

/// Reusable and customizable Background component
/// 
/// Exemple d'utilisation :
/// ```swift
/// UIBackground(
///     type: .gradient(colors: [.blue, .purple]),
///     opacity: 0.8,
///     blur: 2.0
/// )
/// ```
struct UIBackground: View {
    
    // MARK: - Properties
    let type: UIBackgroundType
    let opacity: Double
    let blur: CGFloat
    let ignoresSafeArea: Bool
    
    // MARK: - Initializer
    /// Initialize a new background
    /// - Parameters:
    ///   - type: Background type
    ///   - opacity: Opacity (0.0 to 1.0)
    ///   - blur: Rayon de flou
    ///   - ignoresSafeArea: Ignores safe areas
    init(
        type: UIBackgroundType,
        opacity: Double = 1.0,
        blur: CGFloat = 0,
        ignoresSafeArea: Bool = true
    ) {
        self.type = type
        self.opacity = opacity
        self.blur = blur
        self.ignoresSafeArea = ignoresSafeArea
    }
    
    // MARK: - Body
    var body: some View {
        backgroundContent
            .opacity(opacity)
            .blur(radius: blur)
            .ignoresSafeArea(ignoresSafeArea ? .all : [])
    }
    
    // MARK: - Background Content
    @ViewBuilder
    private var backgroundContent: some View {
        switch type {
        case .solid(let color):
            color
            
        case .gradient(let colors, let startPoint, let endPoint):
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            
        case .radialGradient(let colors, let center, let startRadius, let endRadius):
            RadialGradient(
                colors: colors,
                center: center,
                startRadius: startRadius,
                endRadius: endRadius
            )
            
        case .image(let imageName, let contentMode):
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .clipped()
        }
    }
}

// MARK: - Predefined Backgrounds
extension UIBackground {
    
            /// Primary application background
    static var primary: UIBackground {
        UIBackground(type: .solid(Color(.systemBackground)))
    }
    
            /// Secondary application background
    static var secondary: UIBackground {
        UIBackground(type: .solid(Color(.secondarySystemBackground)))
    }
    
            /// Blue-violet gradient
    static var blueGradient: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Orange-pink gradient
    static var sunsetGradient: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [Color.orange, Color.pink],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
            /// Green gradient
    static var greenGradient: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [Color.green.opacity(0.7), Color.mint],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Central radial gradient
    static var radialBlue: UIBackground {
        UIBackground(
            type: .radialGradient(
                colors: [Color.blue.opacity(0.8), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 400
            )
        )
    }
    
            /// Transparent background with dark overlay
    static var overlay: UIBackground {
        UIBackground(
            type: .solid(Color.black),
            opacity: 0.6
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        ZStack {
            UIBackground.blueGradient
            
            Text("Blue Gradient Background")
                .font(UITheme.Typography.title1)
                .foregroundColor(.white)
        }
        .frame(height: 150)
        
        ZStack {
            UIBackground.sunsetGradient
            
            Text("Sunset Gradient Background")
                .font(UITheme.Typography.title1)
                .foregroundColor(.white)
        }
        .frame(height: 150)
        
        ZStack {
            UIBackground.greenGradient
            
            Text("Green Gradient Background")
                .font(UITheme.Typography.title1)
                .foregroundColor(.white)
        }
        .frame(height: 150)
        
        ZStack {
            UIBackground.radialBlue
            
            Text("Radial Blue Background")
                .font(UITheme.Typography.title1)
                .foregroundColor(.white)
        }
        .frame(height: 150)
        
        ZStack {
            UIBackground.primary
            
            Text("Primary Background")
                .font(UITheme.Typography.title1)
                .foregroundColor(Color(.label))
        }
        .frame(height: 150)
    }
}