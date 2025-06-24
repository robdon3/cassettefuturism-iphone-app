//
//  CultureView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI

struct CultureView: View {
    @State private var selectedSection = 0
    
    var body: some View {
        VStack {
            // Header
            Text("1980s CULTURE")
                .terminalText()
                .font(.title)
                .padding()
            
            // Section tabs
            Picker("Section", selection: $selectedSection) {
                Text("YUPPIES").tag(0)
                Text("ART").tag(1)
                Text("TECH").tag(2)
                Text("LIFESTYLE").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Content
            ScrollView {
                Group {
                    switch selectedSection {
                    case 0:
                        YuppieSection()
                    case 1:
                        ArtSection()
                    case 2:
                        TechSection()
                    case 3:
                        LifestyleSection()
                    default:
                        YuppieSection()
                    }
                }
                .padding()
            }
        }
        .background(CassetteFuturismTheme.backgroundGradient)
    }
}

struct YuppieSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("THE YUPPIE PHENOMENON")
                .terminalText()
                .font(.headline)
            
            CultureCard(
                title: "Young Urban Professional",
                description: "The Yuppie (Young Urban Professional) was a cultural archetype of the 1980s, characterized by materialism, career ambition, and conspicuous consumption.",
                icon: "person.3.fill"
            )
            
            CultureCard(
                title: "Material Success",
                description: "Yuppies were known for their expensive cars, designer clothes, and luxury apartments. They represented the American Dream of upward mobility.",
                icon: "car.fill"
            )
            
            CultureCard(
                title: "Career Focus",
                description: "Work became central to identity, with long hours and high stress seen as badges of honor. The 'work hard, play hard' ethic emerged.",
                icon: "briefcase.fill"
            )
            
            CultureCard(
                title: "Cultural Impact",
                description: "Yuppies influenced fashion, music, and lifestyle trends. They were both celebrated and satirized in popular culture.",
                icon: "music.note"
            )
        }
    }
}

struct ArtSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("ARTISTIC INFLUENCES")
                .terminalText()
                .font(.headline)
            
            CultureCard(
                title: "Frank Frazetta",
                description: "Master of fantasy and science fiction art. His Conan the Barbarian covers defined sword and sorcery aesthetics for generations.",
                icon: "paintbrush.fill"
            )
            
            CultureCard(
                title: "Norman Rockwell",
                description: "American illustrator whose work captured the essence of American life and values. His Saturday Evening Post covers became cultural touchstones.",
                icon: "photo.fill"
            )
            
            CultureCard(
                title: "Pop Art Movement",
                description: "Art that drew inspiration from commercial culture and mass media. Andy Warhol and others blurred the line between high and low art.",
                icon: "star.fill"
            )
            
            CultureCard(
                title: "Digital Art Emergence",
                description: "The 1980s saw the rise of computer-generated art and digital design, marking the beginning of the digital art revolution.",
                icon: "display"
            )
        }
    }
}

struct TechSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("TECHNOLOGY REVOLUTION")
                .terminalText()
                .font(.headline)
            
            CultureCard(
                title: "Personal Computers",
                description: "The rise of home computers like the Apple II, Commodore 64, and IBM PC brought computing power to everyday people.",
                icon: "desktopcomputer"
            )
            
            CultureCard(
                title: "Arcade Gaming",
                description: "Arcades were social hubs where games like Galaga, Pac-Man, and Space Invaders created a new form of entertainment.",
                icon: "gamecontroller.fill"
            )
            
            CultureCard(
                title: "Cellular Phones",
                description: "The first mobile phones appeared, though they were large and expensive. They symbolized the future of communication.",
                icon: "phone.fill"
            )
            
            CultureCard(
                title: "VHS and Home Video",
                description: "The VCR revolutionized home entertainment, allowing people to watch movies at home and record television shows.",
                icon: "video.fill"
            )
        }
    }
}

struct LifestyleSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("LIFESTYLE & CULTURE")
                .terminalText()
                .font(.headline)
            
            CultureCard(
                title: "Fitness Craze",
                description: "Aerobics, jogging, and health clubs became popular. Jane Fonda's workout videos were cultural phenomena.",
                icon: "figure.run"
            )
            
            CultureCard(
                title: "Shopping Malls",
                description: "Malls became the new town squares, offering shopping, entertainment, and social gathering spaces.",
                icon: "building.2.fill"
            )
            
            CultureCard(
                title: "Fast Food Culture",
                description: "McDonald's, Burger King, and other chains expanded rapidly, changing American eating habits.",
                icon: "fork.knife"
            )
            
            CultureCard(
                title: "Television Dominance",
                description: "MTV launched in 1981, revolutionizing music and youth culture. Cable TV expanded entertainment options.",
                icon: "tv.fill"
            )
        }
    }
}

struct CultureCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(CassetteFuturismTheme.accentOrange)
                
                Text(title)
                    .terminalText()
                    .font(.headline)
            }
            
            Text(description)
                .terminalText()
                .font(.body)
                .lineLimit(nil)
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
    CultureView()
        .background(CassetteFuturismTheme.backgroundGradient)
} 