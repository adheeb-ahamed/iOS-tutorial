//
//  QuizSoundManager.swift
//  ios application
//
//  Created by student5 on 2026-07-15.
//

import AVFoundation
import Combine

@MainActor
final class QuizSoundManager: ObservableObject {

    static let shared = QuizSoundManager()

    private var musicPlayer: AVAudioPlayer?
    private var resultPlayer: AVAudioPlayer?
    private var transitionPlayer: AVAudioPlayer?

    private var introTask: Task<Void, Never>?

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient,
                mode: .default,
                options: [.mixWithOthers]
            )

            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }
    }

    // MARK: - Intro

    func playIntroThenSuspense() {
        stopAllSounds()

        playMusic(
            fileName: "Intro",
            loop: false,
            volume: 0.8
        )

        introTask = Task { @MainActor in
            try? await Task.sleep(
                nanoseconds: 6_000_000_000
            )

            guard !Task.isCancelled else {
                return
            }

            playSuspense()
        }
    }

    // MARK: - Suspense

    func playSuspense() {
        playMusic(
            fileName: "Suspense",
            loop: true,
            volume: 0.45
        )
    }

    func stopSuspense() {
        musicPlayer?.stop()
        musicPlayer = nil
    }

    // MARK: - Answer sounds

    func playCorrectAnswer() {
        playResultSound(
            fileName: "correct",
            volume: 1.0
        )
    }

    func playWrongAnswer() {
        playResultSound(
            fileName: "wrong",
            volume: 1.0
        )
    }

    // MARK: - Next question

    func playNextQuestionSound() {
        guard let url = Bundle.main.url(
            forResource: "nextQuestion",
            withExtension: "mp3"
        ) else {
            print("quiz_next.mp3 was not found")
            return
        }

        do {
            transitionPlayer = try AVAudioPlayer(contentsOf: url)
            transitionPlayer?.volume = 0.8
            transitionPlayer?.prepareToPlay()
            transitionPlayer?.play()
        } catch {
            print("Next-question sound error: \(error.localizedDescription)")
        }
    }

    // MARK: - Stop

    func stopAllSounds() {
        introTask?.cancel()
        introTask = nil

        musicPlayer?.stop()
        resultPlayer?.stop()
        transitionPlayer?.stop()

        musicPlayer = nil
        resultPlayer = nil
        transitionPlayer = nil
    }

    // MARK: - Private functions

    private func playMusic(
        fileName: String,
        loop: Bool,
        volume: Float
    ) {
        musicPlayer?.stop()

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "mp3"
        ) else {
            print("\(fileName).mp3 was not found")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = loop ? -1 : 0
            musicPlayer?.volume = volume
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("Music error: \(error.localizedDescription)")
        }
    }

    private func playResultSound(
        fileName: String,
        volume: Float
    ) {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "mp3"
        ) else {
            print("\(fileName).mp3 was not found")
            return
        }

        do {
            resultPlayer = try AVAudioPlayer(contentsOf: url)
            resultPlayer?.volume = volume
            resultPlayer?.prepareToPlay()
            resultPlayer?.play()
        } catch {
            print("Result sound error: \(error.localizedDescription)")
        }
    }
}
