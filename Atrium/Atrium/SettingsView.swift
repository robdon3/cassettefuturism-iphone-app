//
//  SettingsView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("terminalBlinkRate") private var terminalBlinkRate = 0.5
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("autoSave") private var autoSave = true
    @AppStorage("themeVariant") private var themeVariant = "classic"
    @AppStorage("username") private var username = ""
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad/large screen layout (unchanged)
                VStack {
                    Text("SYSTEM SETTINGS")
                        .terminalText()
                        .font(.title)
                        .padding()
                    ScrollView {
                        VStack(spacing: 20) {
                            settingsSections
                        }
                        .padding()
                    }
                }
                .background(CassetteFuturismTheme.backgroundGradient)
            } else {
                // iPhone/compact layout
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            settingsSections
                        }
                        .padding()
                    }
                    .background(CassetteFuturismTheme.backgroundGradient.ignoresSafeArea())
                    .navigationTitle("Settings")
                }
            }
        }
    }
    
    private var settingsSections: some View {
        Group {
            // User Profile
            SettingsSection(title: "USER PROFILE") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("USERNAME")
                        .terminalText()
                        .font(.caption)
                    TextField("Enter username...", text: $username)
                        .terminalText()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(CassetteFuturismTheme.darkGray)
                }
            }
            // Display Settings
            SettingsSection(title: "DISPLAY") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("TERMINAL BLINK RATE")
                            .terminalText()
                            .font(.caption)
                        Spacer()
                        Text("\(terminalBlinkRate, specifier: "%.1f")s")
                            .terminalText()
                            .font(.caption)
                    }
                    Slider(value: $terminalBlinkRate, in: 0.1...2.0, step: 0.1)
                        .accentColor(CassetteFuturismTheme.primaryGreen)
                    HStack {
                        Text("THEME VARIANT")
                            .terminalText()
                            .font(.caption)
                        Spacer()
                        Picker("Theme", selection: $themeVariant) {
                            Text("CLASSIC").tag("classic")
                            Text("NEON").tag("neon")
                            Text("RETRO").tag("retro")
                            Text("TEENAGE").tag("teenage")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(CassetteFuturismTheme.darkGray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 1)
                                )
                        )
                    }
                }
            }
            // Audio Settings
            SettingsSection(title: "AUDIO") {
                HStack {
                    Text("SOUND EFFECTS")
                        .terminalText()
                        .font(.caption)
                    Spacer()
                    Toggle("", isOn: $soundEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: CassetteFuturismTheme.primaryGreen))
                }
            }
            // Data Settings
            SettingsSection(title: "DATA") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("AUTO SAVE")
                            .terminalText()
                            .font(.caption)
                        Spacer()
                        Toggle("", isOn: $autoSave)
                            .toggleStyle(SwitchToggleStyle(tint: CassetteFuturismTheme.primaryGreen))
                    }
                    Button("EXPORT DATA") {
                        exportData()
                    }
                    .buttonStyle(CassetteButtonStyle())
                    Button("IMPORT DATA") {
                        importData()
                    }
                    .buttonStyle(CassetteButtonStyle())
                }
            }
            // About Section
            SettingsSection(title: "ABOUT") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("ATRIUM v1.0")
                        .terminalText()
                        .font(.headline)
                    Text("Cassette Futurism Experience")
                        .terminalText()
                        .font(.caption)
                    Text("Inspired by the 1980s aesthetic")
                        .terminalText()
                        .font(.caption)
                    Divider()
                        .background(CassetteFuturismTheme.primaryGreen)
                    Text("Influences:")
                        .terminalText()
                        .font(.caption)
                    Text("• Conan the Barbarian (1982)")
                        .terminalText()
                        .font(.caption)
                    Text("• WarGames (1983)")
                        .terminalText()
                        .font(.caption)
                    Text("• Galaga (1981)")
                        .terminalText()
                        .font(.caption)
                    Text("• Frank Frazetta Art")
                        .terminalText()
                        .font(.caption)
                    Text("• Norman Rockwell Americana")
                        .terminalText()
                        .font(.caption)
                }
            }
        }
    }
    
    private func exportData() {
        // Placeholder for data export functionality
        print("Export data functionality would go here")
    }
    
    private func importData() {
        // Placeholder for data import functionality
        print("Import data functionality would go here")
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .terminalText()
                .font(.headline)
                .foregroundColor(CassetteFuturismTheme.accentOrange)
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(CassetteFuturismTheme.mediumGray)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 1)
                )
        )
    }
}

#Preview {
    SettingsView()
        .background(CassetteFuturismTheme.backgroundGradient)
} 