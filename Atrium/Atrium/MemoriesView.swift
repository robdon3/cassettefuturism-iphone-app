//
//  MemoriesView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI
import SwiftData

struct MemoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var memories: [CassetteMemory]
    @State private var showingAddMemory = false
    @State private var selectedCategory = "all"
    
    private let categories = [
        "all", "conan", "wargames", "galaga", "yuppie", "frazetta", "rockwell", "general"
    ]
    
    var filteredMemories: [CassetteMemory] {
        if selectedCategory == "all" {
            return memories
        } else {
            return memories.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("CASSETTE MEMORIES")
                    .terminalText()
                    .font(.title)
                Spacer()
                Button("ADD MEMORY") {
                    showingAddMemory = true
                }
                .buttonStyle(CassetteButtonStyle())
            }
            .padding()
            
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category.uppercased())
                                .terminalText()
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(selectedCategory == category ? 
                                              CassetteFuturismTheme.primaryGreen : 
                                              CassetteFuturismTheme.mediumGray)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            // Memories list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredMemories) { memory in
                        MemoryCard(memory: memory)
                    }
                }
                .padding()
            }
        }
        .background(CassetteFuturismTheme.backgroundGradient)
        .sheet(isPresented: $showingAddMemory) {
            AddMemoryView()
        }
    }
}

struct MemoryCard: View {
    let memory: CassetteMemory
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(memory.title)
                        .terminalText()
                        .font(.headline)
                    
                    Text(memory.category.uppercased())
                        .terminalText()
                        .font(.caption)
                        .foregroundColor(CassetteFuturismTheme.accentOrange)
                }
                
                Spacer()
                
                Button(action: { toggleFavorite() }) {
                    Image(systemName: memory.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(memory.isFavorite ? .red : CassetteFuturismTheme.primaryGreen)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Content
            Text(memory.content)
                .terminalText()
                .font(.body)
                .lineLimit(3)
            
            // Footer
            HStack {
                Text(memory.createdAt, style: .date)
                    .terminalText()
                    .font(.caption)
                
                Spacer()
                
                Button("DELETE") {
                    deleteMemory()
                }
                .terminalText()
                .font(.caption)
                .foregroundColor(.red)
            }
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
    
    private func toggleFavorite() {
        memory.isFavorite.toggle()
    }
    
    private func deleteMemory() {
        modelContext.delete(memory)
    }
}

struct AddMemoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory = "general"
    
    private let categories = [
        "conan", "wargames", "galaga", "yuppie", "frazetta", "rockwell", "general"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title input
                VStack(alignment: .leading) {
                    Text("TITLE")
                        .terminalText()
                        .font(.caption)
                    
                    TextField("Enter title...", text: $title)
                        .terminalText()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(CassetteFuturismTheme.darkGray)
                }
                
                // Category picker
                VStack(alignment: .leading) {
                    Text("CATEGORY")
                        .terminalText()
                        .font(.caption)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.uppercased())
                                .terminalText()
                                .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(CassetteFuturismTheme.darkGray)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 1)
                            )
                    )
                }
                
                // Content input
                VStack(alignment: .leading) {
                    Text("CONTENT")
                        .terminalText()
                        .font(.caption)
                    
                    TextEditor(text: $content)
                        .terminalText()
                        .frame(minHeight: 200)
                        .background(CassetteFuturismTheme.darkGray)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(CassetteFuturismTheme.primaryGreen, lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .padding()
            .background(CassetteFuturismTheme.backgroundGradient)
            .navigationTitle("ADD MEMORY")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("CANCEL") {
                        dismiss()
                    }
                    .buttonStyle(CassetteButtonStyle())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("SAVE") {
                        saveMemory()
                    }
                    .buttonStyle(CassetteButtonStyle())
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func saveMemory() {
        let newMemory = CassetteMemory(
            title: title,
            content: content,
            category: selectedCategory
        )
        modelContext.insert(newMemory)
        dismiss()
    }
}

#Preview {
    MemoriesView()
        .modelContainer(for: CassetteMemory.self, inMemory: true)
} 