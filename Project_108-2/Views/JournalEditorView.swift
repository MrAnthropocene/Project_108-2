// JournalEditorView.swift
// Creates or edits a journal entry (CRUD). Applies visual improvements and organizes content with VStack.

import SwiftUI
import SwiftData

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    // Editable fields
    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var date: Date = .now
    @State private var category: String = "Personal"

    // Optional entry for editing
    var entry: JournalEntry?

    private let categories = ["Work", "Personal", "School"]

    init(entry: JournalEntry? = nil) {
        self.entry = entry
    }

    var body: some View {
        VStack(spacing: 16) {
            // Form header
            VStack(alignment: .leading, spacing: 10) {
                TextField("Title", text: $title)
                    .textFieldStyle(.roundedBorder)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
                .pickerStyle(.segmented)

                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
            }
            .padding()
            .background(Color.secondary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Text editor
            TextEditor(text: $bodyText)
                .padding(8)
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .background(Color.secondary.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // Actions
            HStack {
                if entry != nil {
                    Button(role: .destructive) {
                        deleteEntry()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Spacer()
                }

                Button {
                    saveEntry()
                } label: {
                    Label("Save", systemImage: "checkmark.circle.fill")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
        .onAppear {
            if let entry {
                title = entry.title
                bodyText = entry.body
                date = entry.date
                category = entry.category
            }
        }
    }

    // Save changes (create or edit)
    private func saveEntry() {
        if let entry {
            entry.title = title
            entry.body = bodyText
            entry.date = date
            entry.category = category
        } else {
            let new = JournalEntry(title: title, body: bodyText, date: date, category: category)
            context.insert(new)
        }
        try? context.save()
        dismiss()
    }

    // Delete the current entry
    private func deleteEntry() {
        if let entry {
            context.delete(entry)
            try? context.save()
            dismiss()
        }
    }
}

