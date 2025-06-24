//
//  MemoriesView.swift
//  Atrium
//
//  Created by Robert Donohue on 6/24/25.
//

import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation

struct MemoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var memories: [CassetteMemory]
    @State private var showingAddMemory = false
    @State private var selectedCategory = "all"
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
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
        Group {
            if horizontalSizeClass == .regular {
                // iPad/large screen layout (unchanged)
                VStack {
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
            } else {
                // iPhone/compact layout
                NavigationStack {
                    VStack(spacing: 0) {
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
                            .padding(.top, 8)
                        }
                        // Memories list
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredMemories) { memory in
                                    MemoryCard(memory: memory)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .background(CassetteFuturismTheme.backgroundGradient.ignoresSafeArea())
                    .navigationTitle("Memories")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showingAddMemory = true }) {
                                Label("Add Memory", systemImage: "plus")
                            }
                            .buttonStyle(CassetteButtonStyle())
                        }
                    }
                    .sheet(isPresented: $showingAddMemory) {
                        AddMemoryView()
                    }
                }
            }
        }
    }
}

struct MemoryCard: View {
    let memory: CassetteMemory
    @Environment(\.modelContext) private var modelContext
    @State private var isSharing = false
    
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
                Button(action: { isSharing = true }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(CassetteFuturismTheme.primaryGreen)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Image preview
            if let data = memory.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 120)
                    .cornerRadius(8)
            }
            
            // Audio preview (stub)
            if memory.audioData != nil {
                HStack {
                    Image(systemName: "waveform")
                        .foregroundColor(CassetteFuturismTheme.primaryGreen)
                    Text("Audio Note Attached")
                        .terminalText()
                        .font(.caption)
                }
            }
            
            // Tags
            if !memory.tags.isEmpty {
                HStack { ForEach(memory.tags, id: \.self) { tag in
                    Text("#" + tag)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(CassetteFuturismTheme.primaryGreen.opacity(0.2))
                        .cornerRadius(6)
                }}
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
        .sheet(isPresented: $isSharing) {
            ShareMemorySheet(memory: memory)
        }
    }
    
    private func toggleFavorite() {
        memory.isFavorite.toggle()
    }
    
    private func deleteMemory() {
        modelContext.delete(memory)
    }
}

// Share sheet for memory
struct ShareMemorySheet: UIViewControllerRepresentable {
    let memory: CassetteMemory
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        var items: [Any] = []
        var text = "\(memory.title)\n\n\(memory.content)\n\nCategory: \(memory.category)"
        if !memory.tags.isEmpty {
            text += "\nTags: " + memory.tags.map { "#\($0)" }.joined(separator: ", ")
        }
        items.append(text)
        if let data = memory.imageData, let image = UIImage(data: data) {
            items.append(image)
        }
        // (Audio sharing can be added if needed)
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct AddMemoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory = "general"
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    @State private var audioData: Data? = nil
    @State private var isRecording = false
    @State private var tagsText = ""
    @State private var tags: [String] = []
    
    private let categories = [
        "conan", "wargames", "galaga", "yuppie", "frazetta", "rockwell", "general"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                    // Image picker
                    VStack(alignment: .leading) {
                        Text("IMAGE")
                            .terminalText()
                            .font(.caption)
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            HStack {
                                Image(systemName: "photo")
                                Text(imageData == nil ? "Add Image" : "Change Image")
                            }
                            .padding(8)
                            .background(CassetteFuturismTheme.mediumGray)
                            .cornerRadius(8)
                        }
                        .onChange(of: selectedImage) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }
                        if let data = imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 180)
                                .cornerRadius(8)
                                .padding(.top, 4)
                        }
                    }
                    // Audio recorder (stub UI)
                    VStack(alignment: .leading) {
                        Text("AUDIO NOTE")
                            .terminalText()
                            .font(.caption)
                        HStack {
                            Button(action: { isRecording.toggle() }) {
                                Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                                    .font(.system(size: 32))
                                    .foregroundColor(isRecording ? .red : CassetteFuturismTheme.primaryGreen)
                            }
                            Text(isRecording ? "Recording... (stub)" : (audioData == nil ? "Record Audio" : "Audio Attached"))
                                .terminalText()
                        }
                        // (Stub: actual audio recording logic can be added later)
                    }
                    // Tags input
                    VStack(alignment: .leading) {
                        Text("TAGS (comma separated)")
                            .terminalText()
                            .font(.caption)
                        TextField("e.g. retro, 80s, synthwave", text: $tagsText)
                            .terminalText()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(CassetteFuturismTheme.darkGray)
                            .onChange(of: tagsText) { newValue in
                                tags = newValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                            }
                        if !tags.isEmpty {
                            HStack { ForEach(tags, id: \.self) { tag in
                                Text("#" + tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(CassetteFuturismTheme.primaryGreen.opacity(0.2))
                                    .cornerRadius(6)
                            }}
                        }
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
            }
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
            category: selectedCategory,
            imageData: imageData,
            audioData: audioData,
            tags: tags
        )
        modelContext.insert(newMemory)
        dismiss()
    }
}

#Preview {
    MemoriesView()
        .modelContainer(for: CassetteMemory.self, inMemory: true)
} 