// ArchivedEntriesView.swift
// Shows archived journal entries with search and swipe actions to unarchive or delete.

import SwiftUI
import SwiftData

// List of archived entries filtered by search text.
struct ArchivedEntriesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]

    @State private var searchText: String = ""

    private var archivedEntries: [JournalEntry] {
        var result = entries.filter { $0.isArchived }

        let s = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !s.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(s) ||
                $0.body.localizedCaseInsensitiveContains(s)
            }
        }

        return result
    }

    var body: some View {
        List {
            // Empty state when no archived entries match
            if archivedEntries.isEmpty {
                ContentUnavailableView(
                    "No archived entries",
                    systemImage: "archivebox",
                    description: Text("Entries you archive will appear here.")
                )
            } else {
                ForEach(archivedEntries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        EntryRowView(entry: entry)
                    }
                    // Leading swipe: unarchive
                    .swipeActions(edge: .leading) {
                        Button {
                            entry.isArchived = false
                        } label: {
                            Label("Unarchive", systemImage: "tray.and.arrow.up")
                        }
                        .tint(.green)
                    }
                    // Trailing swipe: delete
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            context.delete(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.visible)
        .navigationTitle("Archived")
        .searchable(text: $searchText, prompt: "Search archived entries")
    }
}

