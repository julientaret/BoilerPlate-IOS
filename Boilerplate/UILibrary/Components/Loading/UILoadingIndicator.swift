//
//  UILoadingIndicator.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Loading indicator style
/// - circular: Standard circular indicator
/// - dots: Dots animation
/// - pulse: Pulse animation
/// - skeleton: Skeleton loading style
enum UILoadingStyle {
    case circular
    case dots
    case pulse
    case skeleton
}

/// Loading indicator size
/// - small: Compact indicator
/// - medium: Standard size
/// - large: Prominent indicator
enum UILoadingSize {
    case small
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
        case .small: return 20
        case .medium: return 32
        case .large: return 48
        }
    }
    
    var dotSize: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
}

/// Reusable and customizable Loading Indicator component
/// 
/// Exemple d'utilisation :
/// ```swift
/// UILoadingIndicator(
///     style: .circular,
///     size: .medium,
///     color: .blue,
///     message: "Loading..."
/// )
/// ```
struct UILoadingIndicator: View {
    
    // MARK: - Properties
    let style: UILoadingStyle
    let size: UILoadingSize
    let color: Color
    let message: String?
    
    @State private var isAnimating = false
    @State private var dotAnimation = [false, false, false]
    
    // MARK: - Initializer
    /// Initialize a new loading indicator
    /// - Parameters:
    ///   - style: Indicator style
///   - size: Indicator size
    ///   - color: Indicator color
///   - message: Loading message (optional)
    init(
        style: UILoadingStyle = .circular,
        size: UILoadingSize = .medium,
        color: Color = .blue,
        message: String? = nil
    ) {
        self.style = style
        self.size = size
        self.color = color
        self.message = message
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: UITheme.Spacing.md) {
            loadingContent
            
            if let message = message {
                Text(message)
                    .font(UITheme.Typography.body)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Loading Content
    @ViewBuilder
    private var loadingContent: some View {
        switch style {
        case .circular:
            circularIndicator
        case .dots:
            dotsIndicator
        case .pulse:
            pulseIndicator
        case .skeleton:
            skeletonIndicator
        }
    }
    
    // MARK: - Circular Indicator
    private var circularIndicator: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(scaleFactor)
    }
    
    // MARK: - Dots Indicator
    private var dotsIndicator: some View {
        HStack(spacing: UITheme.Spacing.xs) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: size.dotSize, height: size.dotSize)
                    .scaleEffect(dotAnimation[index] ? 1.2 : 0.8)
                    .opacity(dotAnimation[index] ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: dotAnimation[index]
                    )
            }
        }
        .onAppear {
            startDotsAnimation()
        }
    }
    
    // MARK: - Pulse Indicator
    private var pulseIndicator: some View {
        Circle()
            .fill(color.opacity(0.3))
            .frame(width: size.dimension, height: size.dimension)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .opacity(isAnimating ? 0.3 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: isAnimating
            )
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: size.dimension * 0.6, height: size.dimension * 0.6)
            )
            .onAppear {
                isAnimating = true
            }
    }
    
    // MARK: - Skeleton Indicator
    private var skeletonIndicator: some View {
        VStack(spacing: UITheme.Spacing.xs) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: UITheme.CornerRadius.small)
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(0.1),
                                color.opacity(0.3),
                                color.opacity(0.1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 12)
                    .mask(
                        RoundedRectangle(cornerRadius: UITheme.CornerRadius.small)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white, .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: isAnimating ? 200 : -200)
                    )
            }
        }
        .frame(width: size.dimension * 3)
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
    
    // MARK: - Computed Properties
    private var scaleFactor: CGFloat {
        switch size {
        case .small: return 0.8
        case .medium: return 1.0
        case .large: return 1.5
        }
    }
    
    // MARK: - Functions
    private func startDotsAnimation() {
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                dotAnimation[i] = true
            }
        }
    }
}

// MARK: - Full Screen Loading
struct UIFullScreenLoading: View {
    let message: String?
    let style: UILoadingStyle
    let backgroundColor: Color
    
    init(
        message: String? = "Loading...",
        style: UILoadingStyle = .circular,
        backgroundColor: Color = Color(.systemBackground).opacity(0.8)
    ) {
        self.message = message
        self.style = style
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            UILoadingIndicator(
                style: style,
                size: .large,
                message: message
            )
        }
    }
}

#Preview {
    VStack(spacing: UITheme.Spacing.xl) {
        UILoadingIndicator(style: .circular, size: .small, message: "Loading...")
        
        UILoadingIndicator(style: .dots, size: .medium, color: .orange)
        
        UILoadingIndicator(style: .pulse, size: .large, color: .green, message: "Synchronisation...")
        
        UILoadingIndicator(style: .skeleton, size: .medium, color: .blue)
        
        UICard {
            VStack(spacing: UITheme.Spacing.md) {
                Text("Content loading...")
                    .font(UITheme.Typography.headline)
                
                UILoadingIndicator(style: .dots, size: .small, color: .blue)
            }
        }
    }
    .padding()
}