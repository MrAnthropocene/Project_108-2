//
//  Project_108_2Tests.swift
//  Project_108-2Tests
//
//  Created by Saul Herrera on 2/16/26.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let entry: JournalEntry
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.title)
                            .font(.title2)
                            .bold()

                        HStack(spacing: 6) {
                            Text(entry.date.formatted(date: .long, time: .shortened))
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

                    Button {
                        entry.isFavorite.toggle()
                    } label: {
                        Image(systemName: entry.isFavorite ? "star.fill" : "star")
                            .font(.title3)
                    }
                }

                Divider()

                Text(entry.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(role: .destructive) {
                    context.delete(entry)
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            NavigationStack {
                EntryFormView(entry: entry) // Edit
            }
        }
    }

    private var categoryColor: Color {
        switch entry.category {
        case "Work": return .blue
        case "Personal": return .green
        case "School": return .orange
        default: return .gray
        }
    }
}

