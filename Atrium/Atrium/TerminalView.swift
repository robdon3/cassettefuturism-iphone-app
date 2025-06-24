//
//  TerminalView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI

struct TerminalView: View {
    @State private var commandInput = ""
    @State private var terminalOutput: [TerminalLine] = []
    @State private var cursorVisible = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Terminal header
            HStack {
                Text("ATRIUM TERMINAL v1.0")
                    .terminalText()
                    .font(.headline)
                Spacer()
                Text(Date(), style: .time)
                    .terminalText()
                    .font(.caption)
            }
            .padding()
            .background(CassetteFuturismTheme.darkGray)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(CassetteFuturismTheme.primaryGreen),
                alignment: .bottom
            )
            
            // Terminal output area
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    ForEach(terminalOutput) { line in
                        Text(line.content)
                            .terminalText()
                            .font(.system(.body, design: .monospaced))
                    }
                }
                .padding()
            }
            .background(CassetteFuturismTheme.terminalGradient)
            
            // Command input area
            HStack {
                Text("ATRIUM>")
                    .terminalText()
                    .font(.system(.body, design: .monospaced))
                
                TextField("Enter command...", text: $commandInput)
                    .terminalText()
                    .font(.system(.body, design: .monospaced))
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        executeCommand()
                    }
                
                // Blinking cursor
                Text("_")
                    .terminalText()
                    .opacity(cursorVisible ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: cursorVisible)
            }
            .padding()
            .background(CassetteFuturismTheme.darkGray)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(CassetteFuturismTheme.primaryGreen),
                alignment: .top
            )
        }
        .onAppear {
            initializeTerminal()
        }
    }
    
    private func initializeTerminal() {
        addOutput("ATRIUM TERMINAL SYSTEM INITIALIZED")
        addOutput("Welcome to the Cassette Futurism Experience")
        addOutput("Type 'help' for available commands")
        addOutput("")
    }
    
    private func executeCommand() {
        let command = commandInput.trimmingCharacters(in: .whitespacesAndNewlines)
        addOutput("ATRIUM> \(command)")
        
        switch command.lowercased() {
        case "help":
            showHelp()
        case "clear":
            terminalOutput.removeAll()
        case "date":
            addOutput(Date().formatted(date: .complete, time: .complete))
        case "conan":
            showConanInfo()
        case "wargames":
            showWarGamesInfo()
        case "galaga":
            showGalagaInfo()
        case "yuppie":
            showYuppieInfo()
        case "frazetta":
            showFrazettaInfo()
        case "rockwell":
            showRockwellInfo()
        case "exit", "quit":
            addOutput("Terminal session ended. Goodbye!")
        default:
            if !command.isEmpty {
                addOutput("Command not recognized: \(command)")
                addOutput("Type 'help' for available commands")
            }
        }
        
        commandInput = ""
    }
    
    private func addOutput(_ text: String) {
        terminalOutput.append(TerminalLine(content: text))
    }
    
    private func showHelp() {
        addOutput("Available commands:")
        addOutput("  help     - Show this help message")
        addOutput("  clear    - Clear terminal")
        addOutput("  date     - Show current date/time")
        addOutput("  conan    - Conan the Barbarian info")
        addOutput("  wargames - WarGames movie info")
        addOutput("  galaga   - Galaga arcade game info")
        addOutput("  yuppie   - Yuppie culture info")
        addOutput("  frazetta - Frank Frazetta info")
        addOutput("  rockwell - Norman Rockwell info")
        addOutput("  exit     - Exit terminal")
    }
    
    private func showConanInfo() {
        addOutput("CONAN THE BARBARIAN (1982)")
        addOutput("Directed by John Milius")
        addOutput("Starring Arnold Schwarzenegger")
        addOutput("Epic fantasy film based on Robert E. Howard's character")
        addOutput("Features the iconic 'Riddle of Steel' theme")
        addOutput("Inspired by Frank Frazetta's artwork")
    }
    
    private func showWarGamesInfo() {
        addOutput("WARGAMES (1983)")
        addOutput("Directed by John Badham")
        addOutput("Starring Matthew Broderick")
        addOutput("Teenager accidentally hacks into NORAD")
        addOutput("Features iconic computer terminal scenes")
        addOutput("Inspired the 'hacker' aesthetic in popular culture")
    }
    
    private func showGalagaInfo() {
        addOutput("GALAGA (1981)")
        addOutput("Arcade game by Namco")
        addOutput("Space shooter with iconic enemy formations")
        addOutput("Featured in arcades throughout the 1980s")
        addOutput("Part of the golden age of arcade gaming")
    }
    
    private func showYuppieInfo() {
        addOutput("YUPPIE CULTURE")
        addOutput("Young Urban Professional")
        addOutput("1980s cultural phenomenon")
        addOutput("Associated with materialism and career success")
        addOutput("Influenced fashion, music, and lifestyle trends")
    }
    
    private func showFrazettaInfo() {
        addOutput("FRANK FRAZETTA (1928-2010)")
        addOutput("American fantasy and science fiction artist")
        addOutput("Known for Conan the Barbarian covers")
        addOutput("Influenced generations of fantasy artists")
        addOutput("Iconic style defined sword and sorcery art")
    }
    
    private func showRockwellInfo() {
        addOutput("NORMAN ROCKWELL (1894-1978)")
        addOutput("American illustrator and painter")
        addOutput("Known for Saturday Evening Post covers")
        addOutput("Captured American life and values")
        addOutput("Influenced 1980s nostalgia and Americana")
    }
}

struct TerminalLine: Identifiable {
    let id = UUID()
    let content: String
}

#Preview {
    TerminalView()
        .background(CassetteFuturismTheme.backgroundGradient)
} 