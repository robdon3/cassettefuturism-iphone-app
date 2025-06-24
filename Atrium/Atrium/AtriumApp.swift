//
//  AtriumApp.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI
import SwiftData

@main
struct AtriumApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            CassetteMemory.self,
            RetroGame.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Cassette futurism works best in dark mode
        }
        .modelContainer(sharedModelContainer)
        .windowResizability(.contentSize) // Better iPad support
    }
}
