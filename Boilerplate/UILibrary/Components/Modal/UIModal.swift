//
//  UIModal.swift
//  Boilerplate
//
//  Created by Julien TARET on 18/08/2025.
//

import SwiftUI

/// Modal display style
/// - sheet: Modal at bottom of screen (iOS sheet)
/// - fullScreen: Full screen modal
/// - center: Centered modal with overlay
enum UIModalPresentationStyle {
    case sheet
    case fullScreen
    case center
}

/// Modal size for center style
/// - small: Compact modal
/// - medium: Standard size
/// - large: Extended modal
enum UIModalSize {
    case small
    case medium
    case large
    
    var width: CGFloat {
        switch self {
        case .small: return 280
        case .medium: return 320
        case .large: return 400
        }
    }
    
    var maxHeight: CGFloat {
        switch self {
        case .small: return 200
        case .medium: return 400
        case .large: return 600
        }
    }
}

/// Reusable and customizable Modal component
/// 
/// Exemple d'utilisation :
/// ```swift
/// UIModal(
///     isPresented: $showModal,
///     title: "Confirmation",
///     style: .center,
///     size: .medium
/// ) {
///     Text("Modal content")
/// }
/// ```
struct UIModal<Content: View>: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    let title: String?
    let style: UIModalPresentationStyle
    let size: UIModalSize
    let showCloseButton: Bool
    let content: Content
    
    @State private var backgroundOpacity: Double = 0
    @State private var contentOffset: CGFloat = 0
    
    // MARK: - Initializer
    /// Initialize a new modal
    /// - Parameters:
    ///   - isPresented: Binding to control display
    ///   - title: Modal title (optional)
    ///   - style: Presentation style
    ///   - size: Modal size (for center style)
    ///   - showCloseButton: Shows close button
///   - content: Modal content
    init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        style: UIModalPresentationStyle = .center,
        size: UIModalSize = .medium,
        showCloseButton: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.title = title
        self.style = style
        self.size = size
        self.showCloseButton = showCloseButton
        self.content = content()
    }
    
    // MARK: - Body
    var body: some View {
        if isPresented {
            ZStack {
                backgroundView
                
                switch style {
                case .sheet:
                    sheetView
                case .fullScreen:
                    fullScreenView
                case .center:
                    centerView
                }
            }
            .animation(UITheme.Animation.medium, value: isPresented)
            .onAppear {
                withAnimation(UITheme.Animation.medium) {
                    backgroundOpacity = 1
                    contentOffset = 0
                }
            }
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        Color.black
            .opacity(backgroundOpacity * 0.15)
            .ignoresSafeArea()
            .onTapGesture {
                dismiss()
            }
    }
    
    // MARK: - Sheet View
    private var sheetView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                if let title = title {
                    headerView(title: title)
                }
                
                content
                    .padding(UITheme.Spacing.md)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(UITheme.CornerRadius.large, corners: [.topLeft, .topRight])
            .offset(y: contentOffset)
        }
        .onAppear {
            contentOffset = 300
            withAnimation(UITheme.Animation.spring) {
                contentOffset = 0
            }
        }
    }
    
    // MARK: - Full Screen View
    private var fullScreenView: some View {
        VStack(spacing: 0) {
            if let title = title {
                headerView(title: title)
                    .background(Color(.secondarySystemBackground))
            }
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Center View
    private var centerView: some View {
        ZStack {
            VStack(spacing: 0) {
                if let title = title {
                    centerHeaderView(title: title)
                }
                
                content
                    .padding(UITheme.Spacing.md)
            }
            .frame(maxWidth: size.width)
            .frame(maxHeight: size.maxHeight)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(UITheme.CornerRadius.large)
            .shadow(
                color: UITheme.Shadow.large.color,
                radius: UITheme.Shadow.large.radius,
                x: UITheme.Shadow.large.x,
                y: UITheme.Shadow.large.y
            )
            
            // Fixed close button in top right
            if showCloseButton {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: dismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(.secondaryLabel))
                                .background(Circle().fill(Color(.secondarySystemBackground)))
                        }
                        .padding(UITheme.Spacing.sm)
                    }
                    Spacer()
                }
            }
        }
        .scaleEffect(backgroundOpacity)
        .opacity(backgroundOpacity)
    }
    
    // MARK: - Header View
    private func headerView(title: String) -> some View {
        HStack {
            Text(title)
                .font(UITheme.Typography.headline)
                .foregroundColor(Color(.label))
            
            Spacer()
            
            if showCloseButton {
                Button(action: dismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
        }
        .padding(UITheme.Spacing.md)
    }
    
    // MARK: - Center Header View (without close button)
    private func centerHeaderView(title: String) -> some View {
        HStack {
            Text(title)
                .font(UITheme.Typography.headline)
                .foregroundColor(Color(.label))
            
            Spacer()
        }
        .padding(UITheme.Spacing.md)
    }
    
    // MARK: - Actions
    private func dismiss() {
        withAnimation(UITheme.Animation.medium) {
            backgroundOpacity = 0
            contentOffset = style == .sheet ? 300 : 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// MARK: - Corner Radius Extension
private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    @Previewable @State var showModal = true
    
    return ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()
        
        UIModal(
            isPresented: $showModal,
            title: "Exemple Modal",
            style: .center,
            size: .medium
        ) {
            VStack(spacing: UITheme.Spacing.md) {
                Text("Ceci est le contenu de la modal.")
                
                UIButton(title: "Action", style: .primary) {
                    showModal = false
                }
            }
        }
    }
}