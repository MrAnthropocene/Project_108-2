// JournalListView.swift
// Shows all entries with search, category chips, and sorting using @Query.
// Organizes content with VStack and applies visual enhancements.

import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("defaultCategory") private var defaultCategory: String = "Personal"

    // Search by title or body
    @State private var searchText: String = ""

    // Category filter (chip-style tabs)
    @State private var selectedCategory: String = "Todas"

    // Sort by date descending using @Query
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]

    private let categories = ["Todas", "Work", "Personal", "School"]

    // In-memory filtering combining category and search text
    private var filteredEntries: [JournalEntry] {
        entries.filter { entry in
            let matchesCategory = selectedCategory == "Todas" || entry.category == selectedCategory
            let matchesSearch = searchText.isEmpty
                || entry.title.localizedCaseInsensitiveContains(searchText)
                || entry.body.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Category tabs as horizontal chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color.blue.opacity(0.15) : Color.secondary.opacity(0.1))
                                .foregroundStyle(selectedCategory == category ? .blue : .primary)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }

            // Entries list
            List {
                ForEach(filteredEntries) { entry in
                    NavigationLink {
                        JournalEditorView(entry: entry)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(entry.title)
                                    .font(.headline)
                                Spacer()
                                Text(entry.category)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                            Text(entry.body)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .onDelete(perform: deleteEntries)
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Journal")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    JournalEditorView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .accessibilityLabel("New entry")
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search by title or content")
        .padding(.top, 4)
    }

    // Delete selected entries and persist changes
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredEntries[index])
        }
        try? context.save()
    }
}
