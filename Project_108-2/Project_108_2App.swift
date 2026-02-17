//
//  Project_108_2Tests.swift
//  Project_108-2Tests
//
//  Created by Saul Herrera on 2/16/26.
//

import SwiftUI
import SwiftData

@main
struct Class04App: App {
    @AppStorage("appTheme") private var appTheme: String = "system"

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    EntryListView()
                }
                .tabItem {
                    Label("Journal", systemImage: "book")
                }

                NavigationStack {
                    ArchivedEntriesView()
                }
                .tabItem {
                    Label("Archived", systemImage: "archivebox")
                }

                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .preferredColorScheme(colorScheme)
        }
        .modelContainer(for: JournalEntry.self)
    }

    private var colorScheme: ColorScheme? {
        switch appTheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
