//
// EntryFormView.swift
// Creates or edits a journal entry using a form with title, body, category, and favorite fields. Saves to SwiftData and dismisses on completion.
//

import SwiftUI
import SwiftData

// Form-based editor for creating or updating entries.
struct EntryFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let entry: JournalEntry? // nil = create

    @AppStorage("defaultCategory") private var defaultCategory: String = "Personal"

    @State private var title: String = ""
    @State private var entryBody: String = ""
    @State private var isFavorite: Bool = false
    @State private var category: String = ""

    var body: some View {
        Form {
            // Organized into sections for clarity
            Section("Title") {
                TextField("Title", text: $title)
            }

            Section("Body") {
                TextEditor(text: $entryBody)
                    .padding(8)
                    .frame(minHeight: 180)
                    .background(Color.secondary.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Section("Category") {
                Picker("Category", selection: $category) {
                    Text("Work").tag("Work")
                    Text("Personal").tag("Personal")
                    Text("School").tag("School")
                }
                .pickerStyle(.segmented)
                .tint(.blue)
            }

            Section {
                Toggle("Favorite", isOn: $isFavorite)
            }
        }
        .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") { save() }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            if let entry {
                title = entry.title
                entryBody = entry.body
                isFavorite = entry.isFavorite
                category = entry.category
            } else {
                category = defaultCategory
            }
        }
    }

    // Persist changes to SwiftData and close the form
    private func save() {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let b = entryBody.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }

        if let entry {
            entry.title = t
            entry.body = b
            entry.isFavorite = isFavorite
            entry.category = category
        } else {
            context.insert(JournalEntry(title: t, body: b, isFavorite: isFavorite, category: category))
        }

        dismiss()
    }
}
