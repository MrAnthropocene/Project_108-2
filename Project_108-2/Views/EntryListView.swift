//
// EntryListView.swift
// Displays active (non-archived) journal entries with search, favorites filter, category filter, and sort options. Provides swipe actions for favorite, archive, and delete, and navigates to detail and create views.
//

import SwiftUI
import SwiftData

// Main list view for the journal. Uses in-memory filtering and sorting over a SwiftData-backed @Query.

struct EntryListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]

    @State private var searchText: String = ""
    @State private var showFavoritesOnly: Bool = false
    @State private var showNotFavoritesOnly: Bool = false
    @State private var sortNewestFirst: Bool = true
    @State private var selectedCategory: String = "All"

    private var filteredEntries: [JournalEntry] {
        var result = entries.filter { !$0.isArchived }

        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        } else if showNotFavoritesOnly {
            result = result.filter { !$0.isFavorite }
        }

        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }

        let s = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !s.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(s) ||
                $0.body.localizedCaseInsensitiveContains(s)
            }
        }

        result.sort { a, b in
            sortNewestFirst ? (a.date > b.date) : (a.date < b.date)
        }

        return result
    }

    var body: some View {
        List {
            // Empty state when no entries match the current filters/search
            if filteredEntries.isEmpty {
                ContentUnavailableView(
                    "No entries",
                    systemImage: "book.closed",
                    description: Text("Tap + to add your first journal entry.")
                )
            } else {
                ForEach(filteredEntries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        EntryRowView(entry: entry)
                    }
                    // Leading swipe: toggle favorite
                    .swipeActions(edge: .leading) {
                        Button {
                            entry.isFavorite.toggle()
                        } label: {
                            Label(entry.isFavorite ? "Unfavorite" : "Favorite",
                                  systemImage: entry.isFavorite ? "star.slash" : "star.fill")
                        }
                        .tint(.yellow)
                    }
                    // Trailing swipe: delete or archive
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            context.delete(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            entry.isArchived = true
                        } label: {
                            Label("Archive", systemImage: "archivebox")
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.visible)
        .navigationTitle("Journal")
        .searchable(text: $searchText, prompt: "Search title or body")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    EntryFormView(entry: nil) // Create
                } label: {
                    Image(systemName: "plus")
                }
            }

            // Filter & sort controls presented as a menu on the trailing toolbar
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Toggle("Favorites only", isOn: $showFavoritesOnly)
                    Toggle("Not favorites only", isOn: $showNotFavoritesOnly)

                    Divider()

                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        Text("Work").tag("Work")
                        Text("Personal").tag("Personal")
                        Text("School").tag("School")
                    }
                    .tint(.blue)

                    Divider()

                    Picker("Sort", selection: $sortNewestFirst) {
                        Text("Newest first").tag(true)
                        Text("Oldest first").tag(false)
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .onChange(of: showFavoritesOnly) { oldValue, newValue in
            if newValue { showNotFavoritesOnly = false }
        }
        .onChange(of: showNotFavoritesOnly) { oldValue, newValue in
            if newValue { showFavoritesOnly = false }
        }
    }
}

// Compact visual representation for a journal entry row with title, date, category badge, and favorite star.
struct EntryRowView: View {
    let entry: JournalEntry

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(entry.title)
                        .font(.headline)
                        .lineLimit(1)

                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }

                HStack(spacing: 6) {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Text(entry.category)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(categoryColor.opacity(0.2))
                        .foregroundStyle(categoryColor)
                        .clipShape(Capsule())
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
    }

    // Color used for the category capsule
    private var categoryColor: Color {
        switch entry.category {
        case "Work": return .blue
        case "Personal": return .green
        case "School": return .orange
        default: return .gray
        }
    }
}
