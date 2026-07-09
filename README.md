# Velocity - iOS Mini Game Collection

Velocity is an iOS application built using **SwiftUI** that combines multiple mini-games into a single interactive experience. The application is designed to improve players' reaction speed, memory, and general knowledge while providing statistics, achievements, location-based game history, and daily challenges.

---

# Features

## 🎯 Tap Frenzy

A reaction speed game where players tap randomly appearing targets before time runs out.

### Features

* 60-second gameplay
* Random target generation
* Live score tracking
* High score saving
* Final results screen
* Share score functionality

---

## 💡 Light It Up

A memory game where players must remember highlighted tiles and tap the correct sequence.

### Features

* Multiple difficulty levels
* Increasing board size
* Timer-based gameplay
* Score tracking
* Level progression

---

## ❓ Quiz Rush

A trivia game powered by the Open Trivia Database API.

### Features

* Downloads 10 trivia questions
* Multiple-choice answers
* Instant answer feedback
* Score calculation
* Retry functionality
* Loading and error states

---

## 📊 Statistics Dashboard

The application records every completed game session and provides useful statistics including:

* Total games played
* Total score
* Highest score
* Average score
* Game distribution
* Recent activity

---

## 🗺️ Game History Map

Every completed game is stored together with the user's location.

Features include:

* Interactive map
* Saved game locations
* Grouped game markers
* Game history popup
* Timestamp for every session
* Score display
* Game mode information

---

## 🔔 Daily Challenge Notifications

Users can receive a daily reminder encouraging them to play.

Features include:

* Enable/Disable notifications
* Select reminder time
* Daily repeating notification
* Notification permission handling

---

## ⚙️ Settings

The Settings page allows users to customize the application.

Features include:

* Notification toggle
* Reminder time selection
* Automatic preference saving using AppStorage

---

## 📤 Share Results

Players can share their game results using the built-in iOS Share Sheet.

---

# Application Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture.

```
Views
│
├── Main Menu
├── Tap Frenzy
├── Light It Up
├── Quiz Rush
├── Statistics
├── Map
└── Settings

↓

ViewModels

↓

Services

↓

Models
```

This separation keeps the project clean, reusable, and easy to maintain.

---

# Technologies Used

* Swift
* SwiftUI
* MVVM Architecture
* Combine
* Foundation
* MapKit
* Core Location
* UserNotifications
* URLSession
* JSONDecoder
* AppStorage
* Codable

---

# Project Structure

```
ios-application/

├── Models/
│   ├── Question.swift
│   ├── QuizResponse.swift
│   ├── GameSessionModel.swift
│
├── Services/
│   ├── QuizService.swift
│   ├── NotificationManager.swift
│   ├── GameSessionManager.swift
│
├── ViewModels/
│   └── QuizViewModel.swift
│
├── Views/
│   ├── MainView.swift
│   ├── TapGame.swift
│   ├── BlinkGame.swift
│   ├── QuizView.swift
│   ├── ResultView.swift
│   ├── StatsView.swift
│   ├── MapView.swift
│   ├── SettingsView.swift
│   └── Components/
│
└── Assets/
```

---

# Data Persistence

The application stores data locally using:

* AppStorage
* UserDefaults
* Codable encoding/decoding

Stored information includes:

* High scores
* Notification settings
* Reminder time
* Completed game sessions
* Statistics

---

# APIs

## Open Trivia Database (OpenTDB)

Quiz questions are retrieved from:

https://opentdb.com/api.php

The application decodes JSON responses using Codable and URLSession.

---

# Location Services

Core Location is used to:

* Request user permission
* Capture the current location
* Save the location after every completed game
* Display game history on the map

---

# Notifications

The application uses UserNotifications to schedule daily reminders.

Users can:

* Grant notification permission
* Choose reminder time
* Enable or disable reminders

---

# Game Session Model

Each completed game stores:

* Unique ID
* Game mode
* Score
* Date and time
* Latitude
* Longitude

This information is later displayed on the statistics dashboard and interactive map.

---

# Screens

The application contains the following primary screens:

* Home
* Tap Frenzy
* Light It Up
* Quiz Rush
* Statistics Dashboard
* Map History
* Settings
* Result Screen

---

# Installation

## Requirements

* macOS
* Xcode 16 or later
* iOS 17 Simulator or later

---

## Steps

1. Clone the repository.

```bash
git clone git@github.com:adheeb-ahamed/iOS-tutorial.git>
```

2. Open the project in Xcode.

3. Select an iOS Simulator.

4. Press **Run** (⌘ + R).

---

# Permissions

The application requires the following permissions:

### Location

Used to save where games were played.

### Notifications

Used for daily challenge reminders.

---

# Future Improvements

Potential future enhancements include:

* Apple Game Center integration
* Online leaderboards
* Achievements and badges
* CloudKit synchronization
* Multiplayer support
* Dark mode customization
* User profiles
* More mini-games
* Sound and background music
* Animations and particle effects

---

# Learning Outcomes

This project demonstrates practical experience with:

* SwiftUI development
* MVVM architecture
* State management
* Networking with REST APIs
* JSON parsing
* Local data persistence
* MapKit integration
* Core Location
* Local notifications
* Navigation in SwiftUI
* Sharing content
* Modular application design

---

# Authors

Developed as an academic iOS application project.

---

# License

This project is intended for educational purposes.
