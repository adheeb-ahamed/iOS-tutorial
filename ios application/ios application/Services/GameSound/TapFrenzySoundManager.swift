//
//  TapFrenzySoundManager.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

import Foundation
import AVFoundation

final class TapFrenzySoundManager {

    static let shared = TapFrenzySoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(
            forResource: soundName,
            withExtension: "mp3"
        ) else {
            print("Could not find \(soundName).mp3")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print(
                "Error playing sound:",
                error.localizedDescription
            )
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
