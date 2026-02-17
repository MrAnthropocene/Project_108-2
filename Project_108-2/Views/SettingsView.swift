// SettingsView.swift — User Settings view: theme, default category, and name using @AppStorage.
//
//  Project_108_2Tests.swift
//  Project_108-2Tests
//
//  Created by Saul Herrera on 2/16/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("defaultCategory") private var defaultCategory: String = "Personal"
    @AppStorage("username") private var username: String = ""

    var body: some View {
        Form {
            // Profile Header
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.15))
                            .frame(width: 56, height: 56)
                        Image(systemName: "person.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.blue)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(username.isEmpty ? "Your name" : username)
                            .font(.headline)
                        Text("Configure your preferences")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            // Appearance
            Section {
                Picker("Theme", selection: $appTheme) {
                    Label("System", systemImage: "circle.lefthalf.filled").tag("system")
                    Label("Light", systemImage: "sun.max.fill").tag("light")
                    Label("Dark", systemImage: "moon.fill").tag("dark")
                }
                .pickerStyle(.segmented)
            } header: {
                Label("Appearance", systemImage: "paintbrush.pointed")
            } footer: {
                Text("Choose how the app looks. 'System' follows the device appearance.")
            }

            // Defaults
            Section {
                Picker("Default Category", selection: $defaultCategory) {
                    Label("Work", systemImage: "briefcase.fill").tag("Work")
                    Label("Personal", systemImage: "person.text.rectangle").tag("Personal")
                    Label("School", systemImage: "book.fill").tag("School")
                }
                .pickerStyle(.menu)
            } header: {
                Label("Default Values", systemImage: "slider.horizontal.3")
            } footer: {
                Text("The category that will be selected by default when creating a new entry.")
            }

            // Profile
            Section {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.secondary)
                    TextField("Your name", text: $username)
                        .textInputAutocapitalization(.words)
                }
            } header: {
                Label("Profile", systemImage: "person")
            } footer: {
                Text("Your name may appear in some views of the app.")
            }
        }
        .navigationTitle("Settings")
        .tint(.blue)
        .formStyle(.grouped)
    }
}

