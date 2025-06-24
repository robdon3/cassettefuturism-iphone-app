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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad or large screen: Use split view
                NavigationSplitView {
                    SidebarView(selectedTab: $selectedTab)
                } content: {
                    MainContentView(selectedTab: selectedTab)
                } detail: {
                    DetailView()
                }
                .navigationSplitViewStyle(.balanced)
                .background(CassetteFuturismTheme.backgroundGradient.ignoresSafeArea())
            } else {
                // iPhone or compact screen: Use stack navigation
                NavigationStack {
                    VStack(spacing: 0) {
                        MainContentView(selectedTab: selectedTab)
                            .ignoresSafeArea()
                        Spacer(minLength: 0)
                        PhoneTabBar(selectedTab: $selectedTab)
                    }
                    .background(CassetteFuturismTheme.backgroundGradient.ignoresSafeArea())
                }
            }
        }
    }
}

// Custom tab bar for iPhone
struct PhoneTabBar: View {
    @Binding var selectedTab: Int
    let tabIcons = ["terminal", "gamecontroller", "book", "person.3", "gear"]
    let tabTitles = ["TERMINAL", "GAMES", "MEMORIES", "CULTURE", "SETTINGS"]
    
    var body: some View {
        HStack {
            ForEach(0..<tabIcons.count, id: \.self) { index in
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 2) {
                        Image(systemName: tabIcons[index])
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(selectedTab == index ? CassetteFuturismTheme.primaryGreen : CassetteFuturismTheme.lightGray)
                        Text(tabTitles[index])
                            .font(.caption2)
                            .foregroundColor(selectedTab == index ? CassetteFuturismTheme.primaryGreen : CassetteFuturismTheme.lightGray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 8)
        .background(CassetteFuturismTheme.mediumGray.ignoresSafeArea(edges: .bottom))
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
