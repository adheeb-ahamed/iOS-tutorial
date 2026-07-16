//
//  BlinkSoundManager.swift
//  ios application
//
//  Created by student5 on 2026-07-16.
//

import Foundation
import AVFoundation

final class BlinkSoundManager {

    static let shared = BlinkSoundManager()

    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?

    private init() {}

    func playBackgroundMusic() {
        guard let soundURL = Bundle.main.url(
            forResource: "LightSound",
            withExtension: "mp3"
        ) else {
            print("Background sound not found.")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient,
                mode: .default
            )

            try AVAudioSession.sharedInstance().setActive(true)

            backgroundMusicPlayer = try AVAudioPlayer(
                contentsOf: soundURL
            )

            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = 0.35
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()

        } catch {
            print(
                "Error playing background music:",
                error.localizedDescription
            )
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }

    func playSoundEffect(named fileName: String) {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "mp3"
        ) else {
            print("Could not find \(fileName).mp3")
            return
        }

        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.prepareToPlay()
            soundEffectPlayer?.play()
        } catch {
            print(
                "Sound effect error:",
                error.localizedDescription
            )
        }
    }
}
