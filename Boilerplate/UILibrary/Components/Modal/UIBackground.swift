//
//  UIBackground.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

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
    
    // MARK: - Basic Backgrounds
    
            /// Primary application background
    static var primary: UIBackground {
        UIBackground(type: .solid(Color(.systemBackground)))
    }
    
            /// Secondary application background
    static var secondary: UIBackground {
        UIBackground(type: .solid(Color(.secondarySystemBackground)))
    }
    
            /// Transparent background with dark overlay
    static var overlay: UIBackground {
        UIBackground(
            type: .solid(Color.black),
            opacity: 0.6
        )
    }
    
    // MARK: - 2025 Trending Gradient Collections
    
    // MARK: Purple & Pink Collection (Most Trending 2025)
    
            /// Ethereal Purple to Pink - Trending 2025
    static var etherealPurplePink: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "ffa8f7"),
                    Color(hex: "f88bff"),
                    Color(hex: "cb80ff")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Deep Purple Galaxy - Bold 2025 Trend
    static var deepPurpleGalaxy: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "aa00ff"),
                    Color(hex: "6f00ff"),
                    Color(hex: "3c00ff")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
            /// Electric Violet Dreams
    static var electricVioletDreams: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "575aff"),
                    Color(hex: "cb80ff"),
                    Color(hex: "ffa8f7")
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
    }
    
    // MARK: Sunset Collection
    
            /// Vibrant Sunset 2025 - Warm Trending
    static var vibrantSunset2025: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "fd5e53"),
                    Color(hex: "ff7b54"),
                    Color(hex: "ff9a8b")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
            /// Golden Hour Magic
    static var goldenHourMagic: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "ff6b35"),
                    Color(hex: "f7931e"),
                    Color(hex: "ffd23f")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: Ocean & Sky Collection
    
            /// Electric Ocean Waves
    static var electricOceanWaves: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "0004ff"),
                    Color(hex: "12a4ff"),
                    Color(hex: "40e0d0")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Dreamy Sky Blue
    static var dreamySkyBlue: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "87CEEB"),
                    Color(hex: "98d8e8"),
                    Color(hex: "f7f7f7")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: Soft & Pastel Collection
    
            /// Soft Pink Serenity - Tranquil 2025 Trend
    static var softPinkSerenity: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "ffe1e1"),
                    Color(hex: "ffd2d2"),
                    Color(hex: "ffb7b7")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Mint Fresh Breeze
    static var mintFreshBreeze: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "e8f5e8"),
                    Color(hex: "b8e6b8"),
                    Color(hex: "87ceeb")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: Bold & Electric Collection
    
            /// Electric Neon Burst
    static var electricNeonBurst: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "ff006e"),
                    Color(hex: "fb5607"),
                    Color(hex: "ffbe0b")
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
    }
    
            /// Cyber Purple Matrix
    static var cyberPurpleMatrix: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "9d00ff"),
                    Color(hex: "5a00ca"),
                    Color(hex: "240090")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: Radial Gradients
    
            /// Cosmic Purple Center - Radial
    static var cosmicPurpleCenter: UIBackground {
        UIBackground(
            type: .radialGradient(
                colors: [
                    Color(hex: "cb80ff").opacity(0.9),
                    Color(hex: "6f00ff").opacity(0.6),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 400
            )
        )
    }
    
            /// Sunset Glow Radial
    static var sunsetGlowRadial: UIBackground {
        UIBackground(
            type: .radialGradient(
                colors: [
                    Color(hex: "fd5e53").opacity(0.8),
                    Color(hex: "ff9a8b").opacity(0.5),
                    Color.clear
                ],
                center: .center,
                startRadius: 50,
                endRadius: 350
            )
        )
    }
    
    // MARK: Theme Collection
    
            /// Light Elegant - Perfect for light mode
    static var lightElegant: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "f0f4f8"),
                    Color(hex: "e8f1f8"),
                    Color(hex: "e0ecf4")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Dark Elegant - Perfect for dark mode
    static var darkElegant: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "1a1a2e"),
                    Color(hex: "16213e"),
                    Color(hex: "0f3460")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Midnight Purple - Sophisticated dark theme
    static var midnightPurple: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "2d1b69"),
                    Color(hex: "11052c"),
                    Color(hex: "000000")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
            /// Dark Ocean Depths
    static var darkOceanDepths: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [
                    Color(hex: "0c0c0c"),
                    Color(hex: "1a237e"),
                    Color(hex: "000051")
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
    }
    
    // MARK: - Legacy Gradients (Updated)
    
            /// Blue-violet gradient (Enhanced)
    static var blueGradient: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [Color(hex: "0004ff"), Color(hex: "cb80ff")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
            /// Orange-pink gradient (Enhanced)
    static var sunsetGradient: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [Color(hex: "fd5e53"), Color(hex: "ffa8f7")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
            /// Green gradient (Enhanced)
    static var greenGradient: UIBackground {
        UIBackground(
            type: .gradient(
                colors: [Color(hex: "b8e6b8"), Color(hex: "87ceeb")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Theme-Adaptive Backgrounds
    
            /// Elegant background that adapts to theme (light/dark)
    static func elegantAdaptive(colorScheme: ColorScheme) -> UIBackground {
        colorScheme == .dark ? .darkElegant : .lightElegant
    }
    
            /// Elegant background using environment color scheme
    static var elegantThemed: UIBackground {
        UIBackground(type: .solid(.clear)) // This will be overridden in the view
    }
}

// MARK: - Theme-Aware Background View
struct ThemeAwareBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        UIBackground.elegantAdaptive(colorScheme: colorScheme)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 8) {
            // 2025 Trending Gradients
            Group {
                ZStack {
                    UIBackground.etherealPurplePink
                    
                    Text("Ethereal Purple Pink - 2025 Trend")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.deepPurpleGalaxy
                    
                    Text("Deep Purple Galaxy")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.vibrantSunset2025
                    
                    Text("Vibrant Sunset 2025")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.electricOceanWaves
                    
                    Text("Electric Ocean Waves")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.goldenHourMagic
                    
                    Text("Golden Hour Magic")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
            }
            
            // Soft & Pastel Collection
            Group {
                ZStack {
                    UIBackground.softPinkSerenity
                    
                    Text("Soft Pink Serenity")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.mintFreshBreeze
                    
                    Text("Mint Fresh Breeze")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .frame(height: 120)
            }
            
            // Bold Collection
            Group {
                ZStack {
                    UIBackground.electricNeonBurst
                    
                    Text("Electric Neon Burst")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.cyberPurpleMatrix
                    
                    Text("Cyber Purple Matrix")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
            }
            
            // Theme Collection
            Group {
                ZStack {
                    UIBackground.lightElegant
                    
                    Text("Light Elegant")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.darkElegant
                    
                    Text("Dark Elegant")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.midnightPurple
                    
                    Text("Midnight Purple")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.darkOceanDepths
                    
                    Text("Dark Ocean Depths")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
            }
            
            // Radial Gradients
            Group {
                ZStack {
                    UIBackground.cosmicPurpleCenter
                    
                    Text("Cosmic Purple Center")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
                
                ZStack {
                    UIBackground.sunsetGlowRadial
                    
                    Text("Sunset Glow Radial")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(height: 120)
            }
        }
        .padding(.horizontal)
    }
}