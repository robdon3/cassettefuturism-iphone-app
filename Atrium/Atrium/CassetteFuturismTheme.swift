//
//  CassetteFuturismTheme.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI

struct CassetteFuturismTheme {
    // Color palette inspired by 1980s tech and cassette futurism
    // Enhanced with Teenage Engineering's minimalist design philosophy
    static let primaryGreen = Color(red: 0.0, green: 0.8, blue: 0.4) // Terminal green
    static let secondaryGreen = Color(red: 0.0, green: 0.6, blue: 0.3) // Darker green
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.0) // Warm orange
    static let neonBlue = Color(red: 0.0, green: 0.7, blue: 1.0) // Electric blue
    static let darkGray = Color(red: 0.1, green: 0.1, blue: 0.1) // Almost black
    static let mediumGray = Color(red: 0.2, green: 0.2, blue: 0.2) // Dark gray
    static let lightGray = Color(red: 0.3, green: 0.3, blue: 0.3) // Medium gray
    static let terminalText = Color(red: 0.0, green: 0.9, blue: 0.5) // Bright terminal green
    
    // Teenage Engineering inspired colors - minimal, functional
    static let pureWhite = Color.white
    static let pureBlack = Color.black
    static let aluminumGray = Color(red: 0.85, green: 0.85, blue: 0.85) // Clean aluminum
    static let steelBlue = Color(red: 0.4, green: 0.5, blue: 0.6) // Industrial steel
    static let warmBeige = Color(red: 0.95, green: 0.93, blue: 0.88) // Warm neutral
    
    // Gradients
    static let backgroundGradient = LinearGradient(
        colors: [darkGray, mediumGray],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let terminalGradient = LinearGradient(
        colors: [Color.black, darkGray],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let neonGradient = LinearGradient(
        colors: [primaryGreen, neonBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Teenage Engineering inspired gradients - clean, minimal
    static let minimalGradient = LinearGradient(
        colors: [pureWhite, warmBeige],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let industrialGradient = LinearGradient(
        colors: [aluminumGray, steelBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// Custom button style inspired by Teenage Engineering's functional design
struct CassetteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(CassetteFuturismTheme.mediumGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 2)
                    )
            )
            .foregroundColor(CassetteFuturismTheme.primaryGreen)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Teenage Engineering inspired minimal button style
struct MinimalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(CassetteFuturismTheme.pureWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(CassetteFuturismTheme.pureBlack, lineWidth: 1)
                    )
            )
            .foregroundColor(CassetteFuturismTheme.pureBlack)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.05), value: configuration.isPressed)
    }
}

// Terminal text style
struct TerminalText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .monospaced))
            .foregroundColor(CassetteFuturismTheme.terminalText)
    }
}

// Teenage Engineering inspired minimal text style
struct MinimalText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .default, weight: .regular))
            .foregroundColor(CassetteFuturismTheme.pureBlack)
    }
}

// Industrial text style for technical elements
struct IndustrialText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .monospaced, weight: .medium))
            .foregroundColor(CassetteFuturismTheme.steelBlue)
    }
}

extension View {
    func terminalText() -> some View {
        modifier(TerminalText())
    }
    
    func minimalText() -> some View {
        modifier(MinimalText())
    }
    
    func industrialText() -> some View {
        modifier(IndustrialText())
    }
}

// Teenage Engineering inspired card style - clean, functional
struct MinimalCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(CassetteFuturismTheme.pureWhite)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
    }
}

// Industrial panel style for technical interfaces
struct IndustrialPanel<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(CassetteFuturismTheme.aluminumGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(CassetteFuturismTheme.steelBlue, lineWidth: 1)
                    )
            )
    }
} 