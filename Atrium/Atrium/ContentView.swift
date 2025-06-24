//
//  ContentView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var memories: [CassetteMemory]
    @Query private var games: [RetroGame]
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationSplitView {
            // Sidebar for iPad
            SidebarView(selectedTab: $selectedTab)
        } content: {
            // Main content area
            MainContentView(selectedTab: selectedTab)
        } detail: {
            // Detail view for iPad
            DetailView()
        }
        .navigationSplitViewStyle(.balanced)
        .background(CassetteFuturismTheme.backgroundGradient)
    }
}

struct SidebarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        List {
            Section("CASSETTE FUTURISM") {
                ForEach(0..<5) { index in
                    Button(action: { selectedTab = index }) {
                        HStack {
                            Image(systemName: tabIcon(for: index))
                                .foregroundColor(CassetteFuturismTheme.primaryGreen)
                            Text(tabTitle(for: index))
                                .terminalText()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .listStyle(SidebarListStyle())
        .background(CassetteFuturismTheme.darkGray)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "terminal"
        case 1: return "gamecontroller"
        case 2: return "book"
        case 3: return "person.3"
        case 4: return "gear"
        default: return "circle"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "TERMINAL"
        case 1: return "GAMES"
        case 2: return "MEMORIES"
        case 3: return "CULTURE"
        case 4: return "SETTINGS"
        default: return "Unknown"
        }
    }
}

struct MainContentView: View {
    let selectedTab: Int
    
    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                TerminalView()
            case 1:
                GamesView()
            case 2:
                MemoriesView()
            case 3:
                CultureView()
            case 4:
                SettingsView()
            default:
                TerminalView()
            }
        }
        .background(CassetteFuturismTheme.backgroundGradient)
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("DETAIL VIEW")
                .terminalText()
                .font(.title)
            Text("Select an item from the sidebar")
                .terminalText()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CassetteFuturismTheme.backgroundGradient)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Item.self, CassetteMemory.self, RetroGame.self], inMemory: true)
}
