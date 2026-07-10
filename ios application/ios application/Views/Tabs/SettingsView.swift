//
//  SettingsView.swift
//  ios application
//

import SwiftUI
import UserNotifications

struct SettingsView: View {

    @State private var reminderTime = Date()
    @State private var notificationsEnabled = false
    @State private var showingEraseAlert = false

    @AppStorage("challengeHour") private var challengeHour = 9
    @AppStorage("challengeMinute") private var challengeMinute = 0

    var body: some View {
        
        ZStack{
            
            LinearGradient(
                    colors: [
                        
                        Color.blue.opacity(0.7),
                        Color.white.opacity(0),
                        Color.cyan.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection

                    notificationsCard

                    dailyChallengeCard

                    dangerZoneCard

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
                .padding(.horizontal)
            }
//            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                reminderTime = Calendar.current.date(
                    bySettingHour: challengeHour,
                    minute: challengeMinute,
                    second: 0,
                    of: Date()
                ) ?? Date()
            }
            .alert("Are you sure?", isPresented: $showingEraseAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Erase Everything", role: .destructive) {
                    eraseAllData()
                }
            } message: {
                Text("This will permanently delete all your game stats, high scores, and reset your settings. This action cannot be undone.")
            }
        }
        
        
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("App Settings")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.primary)

            Text("Manage notifications and data")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 4)
    }

    private var notificationsCard: some View {
        settingsCard(title: "Notifications", icon: "bell.fill") {
            Toggle(isOn: $notificationsEnabled) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Challenge Reminder")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text("Get notified about today's challenge")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .tint(.blue)
            .onChange(of: notificationsEnabled) { _, newValue in
                if newValue {
                    NotificationManager.shared.requestPermission()
                }
            }
        }
    }

    private var dailyChallengeCard: some View {
        settingsCard(title: "Daily Challenge", icon: "calendar") {
            VStack(spacing: 16) {
                DatePicker(
                    "Reminder Time",
                    selection: $reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .font(.system(.body, design: .rounded))

                Button {
                    let components = Calendar.current.dateComponents(
                        [.hour, .minute],
                        from: reminderTime
                    )

                    challengeHour = components.hour ?? 9
                    challengeMinute = components.minute ?? 0

                    NotificationManager.shared.scheduleDailyReminder(
                        hour: challengeHour,
                        minute: challengeMinute
                    )
                } label: {
                    Label("Save Reminder", systemImage: "checkmark.circle.fill")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                                .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
                        )
                }
            }
        }
    }

    private var dangerZoneCard: some View {
        settingsCard(title: "Danger Zone", icon: "exclamationmark.triangle.fill") {
            VStack(alignment: .leading, spacing: 12) {
                Text("This will permanently delete all game stats, high scores, and reset your settings.")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)

                Button(role: .destructive) {
                    showingEraseAlert = true
                } label: {
                    Label("Erase All Data", systemImage: "trash.fill")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.red.opacity(0.1))
                        )
                }
            }
        }
    }

    private func settingsCard<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }

    private func eraseAllData() {
        GameSessionManager.shared.clearSessions()

        UserDefaults.standard.removeObject(forKey: "lightItUpHighScore")
        UserDefaults.standard.removeObject(forKey: "TapGameHighScore")
        UserDefaults.standard.removeObject(forKey: "dailyChallengeCompleted")
        UserDefaults.standard.removeObject(forKey: "todaysChallengeKey")

        UserDefaults.standard.removeObject(forKey: "challengeHour")
        UserDefaults.standard.removeObject(forKey: "challengeMinute")
        challengeHour = 9
        challengeMinute = 0
        reminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        notificationsEnabled = false
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
