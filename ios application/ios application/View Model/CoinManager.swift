//
//  CoinManager.swift
//  ios application
//
//  Created by Student 3 on 2026-07-15.
//

import Foundation
import Combine

final class CoinManager: ObservableObject {
    // Singleton instance
    static let shared = CoinManager()

    // Persisted coin balance
    @Published private(set) var balance: Int {
        didSet {
            UserDefaults.standard.set(balance, forKey: coinBalanceKey)
        }
    }

    private let coinBalanceKey = "coinBalanceKey"

    // Private initializer to enforce singleton
    private init() {
        self.balance = UserDefaults.standard.integer(forKey: coinBalanceKey)
    }

    // Add coins to the balance
    func addCoins(amount: Int) {
        guard amount > 0 else { return }
        balance += amount
    }

    // Spend coins if available; returns true on success
    func spendCoins(amount: Int) -> Bool {
        guard amount > 0, balance >= amount else { return false }
        balance -= amount
        return true
    }

    // Reset coin balance to zero
    func resetCoins() {
        balance = 0
    }
}
