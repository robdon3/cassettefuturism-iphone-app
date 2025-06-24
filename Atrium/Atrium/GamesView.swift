//
//  GamesView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI
import SwiftData

struct GamesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var games: [RetroGame]
    @State private var showingGame = false
    @State private var selectedGame: RetroGame?
    @State private var showingArcade = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad/large screen layout (unchanged)
                VStack {
                    HStack {
                        Text("ARCADE GAMES")
                            .terminalText()
                            .font(.title)
                        Spacer()
                        Button("ADD GAME") {
                            addNewGame()
                        }
                        .buttonStyle(CassetteButtonStyle())
                    }
                    .padding()
                    // Play Arcade CRT button
                    PlayArcadeCard(showingArcade: $showingArcade)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(games) { game in
                                GameCard(game: game) {
                                    selectedGame = game
                                    showingGame = true
                                }
                            }
                        }
                        .padding()
                    }
                }
                .background(CassetteFuturismTheme.backgroundGradient)
                .sheet(isPresented: $showingGame) {
                    if let game = selectedGame {
                        GamePlayView(game: game)
                    }
                }
                .fullScreenCover(isPresented: $showingArcade) {
                    CRTArcadeGameView(showingArcade: $showingArcade)
                }
            } else {
                // iPhone/compact layout
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            PlayArcadeCard(showingArcade: $showingArcade)
                                .padding(.horizontal)
                                .padding(.top)
                            ForEach(games) { game in
                                GameCard(game: game) {
                                    selectedGame = game
                                    showingGame = true
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                    .background(CassetteFuturismTheme.backgroundGradient.ignoresSafeArea())
                    .navigationTitle("Arcade Games")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: addNewGame) {
                                Label("Add Game", systemImage: "plus")
                            }
                            .buttonStyle(CassetteButtonStyle())
                        }
                    }
                    .sheet(isPresented: $showingGame) {
                        if let game = selectedGame {
                            GamePlayView(game: game)
                        }
                    }
                    .fullScreenCover(isPresented: $showingArcade) {
                        CRTArcadeGameView(showingArcade: $showingArcade)
                    }
                }
            }
        }
    }
    
    private func addNewGame() {
        let newGame = RetroGame(name: "New Game", gameType: "arcade")
        modelContext.insert(newGame)
    }
}

struct GameCard: View {
    let game: RetroGame
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                // Game icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(CassetteFuturismTheme.mediumGray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 2)
                        )
                    
                    VStack {
                        Image(systemName: gameIcon(for: game.gameType))
                            .font(.system(size: 40))
                            .foregroundColor(CassetteFuturismTheme.primaryGreen)
                        
                        Text(game.name)
                            .terminalText()
                            .font(.headline)
                        
                        Text("High Score: \(game.highScore)")
                            .terminalText()
                            .font(.caption)
                    }
                }
                .frame(height: 120)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func gameIcon(for gameType: String) -> String {
        switch gameType {
        case "galaga": return "gamecontroller"
        case "space_invaders": return "sparkles"
        case "tetris": return "square.grid.3x3"
        case "pacman": return "circle.fill"
        case "arcade": return "gamecontroller"
        default: return "gamecontroller"
        }
    }
}

struct GamePlayView: View {
    let game: RetroGame
    @Environment(\.dismiss) private var dismiss
    @State private var score = 0
    @State private var gameActive = false
    @State private var playerPosition = CGPoint(x: 0.5, y: 0.8)
    @State private var enemies: [Enemy] = []
    @State private var bullets: [Bullet] = []
    @State private var gameTimer: Timer?
    
    var body: some View {
        ZStack {
            // Background
            CassetteFuturismTheme.terminalGradient
                .ignoresSafeArea()
            
            VStack {
                // Game header
                HStack {
                    Text("SCORE: \(score)")
                        .terminalText()
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("EXIT") {
                        dismiss()
                    }
                    .buttonStyle(CassetteButtonStyle())
                }
                .padding()
                
                // Game area
                GeometryReader { geometry in
                    ZStack {
                        // Player ship
                        PlayerShip(position: playerPosition)
                            .position(
                                x: playerPosition.x * geometry.size.width,
                                y: playerPosition.y * geometry.size.height
                            )
                        
                        // Enemies
                        ForEach(enemies) { enemy in
                            EnemyShip(enemy: enemy)
                                .position(
                                    x: enemy.position.x * geometry.size.width,
                                    y: enemy.position.y * geometry.size.height
                                )
                        }
                        
                        // Bullets
                        ForEach(bullets) { bullet in
                            BulletView()
                                .position(
                                    x: bullet.position.x * geometry.size.width,
                                    y: bullet.position.y * geometry.size.height
                                )
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = value.location.x / geometry.size.width
                                let newY = value.location.y / geometry.size.height
                                playerPosition = CGPoint(
                                    x: max(0.1, min(0.9, newX)),
                                    y: max(0.6, min(0.9, newY))
                                )
                            }
                    )
                }
                .background(CassetteFuturismTheme.darkGray)
                .cornerRadius(8)
                .padding()
            }
        }
        .onAppear {
            startGame()
        }
        .onDisappear {
            stopGame()
        }
    }
    
    private func startGame() {
        gameActive = true
        spawnEnemies()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateGame()
        }
    }
    
    private func stopGame() {
        gameActive = false
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func spawnEnemies() {
        for row in 0..<3 {
            for col in 0..<5 {
                let enemy = Enemy(
                    position: CGPoint(
                        x: 0.1 + Double(col) * 0.15,
                        y: 0.1 + Double(row) * 0.1
                    ),
                    direction: 1
                )
                enemies.append(enemy)
            }
        }
    }
    
    private func updateGame() {
        // Update enemy positions
        for i in enemies.indices {
            enemies[i].position.x += 0.001 * enemies[i].direction
            
            if enemies[i].position.x > 0.9 || enemies[i].position.x < 0.1 {
                enemies[i].direction *= -1
                enemies[i].position.y += 0.02
            }
        }
        
        // Update bullet positions
        bullets = bullets.compactMap { bullet in
            var newBullet = bullet
            newBullet.position.y -= 0.02
            
            // Remove bullets that go off screen
            if newBullet.position.y < 0 {
                return nil
            }
            
            // Check for collisions
            for (enemyIndex, enemy) in enemies.enumerated() {
                if abs(newBullet.position.x - enemy.position.x) < 0.05 &&
                   abs(newBullet.position.y - enemy.position.y) < 0.05 {
                    enemies.remove(at: enemyIndex)
                    score += 100
                    return nil
                }
            }
            
            return newBullet
        }
        
        // Auto-fire
        if Int.random(in: 0...20) == 0 {
            bullets.append(Bullet(position: playerPosition))
        }
    }
}

struct PlayerShip: View {
    let position: CGPoint
    
    var body: some View {
        VStack(spacing: 0) {
            // Ship body
            Triangle()
                .fill(CassetteFuturismTheme.primaryGreen)
                .frame(width: 20, height: 30)
            
            // Engine glow
            Rectangle()
                .fill(CassetteFuturismTheme.accentOrange)
                .frame(width: 4, height: 8)
        }
    }
}

struct EnemyShip: View {
    let enemy: Enemy
    
    var body: some View {
        VStack(spacing: 0) {
            // Enemy body
            Triangle()
                .fill(CassetteFuturismTheme.neonBlue)
                .frame(width: 16, height: 24)
                .rotationEffect(.degrees(180))
        }
    }
}

struct BulletView: View {
    var body: some View {
        Circle()
            .fill(CassetteFuturismTheme.accentOrange)
            .frame(width: 4, height: 4)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Enemy: Identifiable {
    let id = UUID()
    var position: CGPoint
    var direction: Double
}

struct Bullet: Identifiable {
    let id = UUID()
    var position: CGPoint
}

struct PlayArcadeCard: View {
    @Binding var showingArcade: Bool
    var body: some View {
        Button(action: { showingArcade = true }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(CassetteFuturismTheme.neonBlue, lineWidth: 3)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(CassetteFuturismTheme.darkGray)
                            .shadow(color: CassetteFuturismTheme.neonBlue.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                VStack(spacing: 8) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 40))
                        .foregroundColor(CassetteFuturismTheme.neonBlue)
                    Text("PLAY ARCADE")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(CassetteFuturismTheme.neonBlue)
                        .shadow(color: CassetteFuturismTheme.neonBlue.opacity(0.5), radius: 2, x: 0, y: 1)
                }
            }
            .frame(height: 100)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CRTArcadeGameView: View {
    @Binding var showingArcade: Bool
    var body: some View {
        ZStack {
            // CRT background
            CassetteFuturismTheme.terminalGradient
                .ignoresSafeArea()
            // CRT overlay
            CRTOverlay()
            // Placeholder for game area
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingArcade = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                    .padding()
                }
                Spacer()
                Text("CRT Arcade Game Coming Soon!")
                    .font(.title)
                    .foregroundColor(CassetteFuturismTheme.neonBlue)
                    .shadow(color: CassetteFuturismTheme.neonBlue.opacity(0.7), radius: 8)
                Spacer()
            }
        }
    }
}

struct CRTOverlay: View {
    var body: some View {
        ZStack {
            // Scanlines
            VStack(spacing: 2) {
                ForEach(0..<120, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black.opacity(0.07))
                        .frame(height: 1)
                }
            }
            // Vignette
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.35), .clear, Color.black.opacity(0.35)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), .clear, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            // Subtle screen curve
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color.white.opacity(0.08), lineWidth: 8)
                .padding(12)
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    GamesView()
        .modelContainer(for: RetroGame.self, inMemory: true)
} 