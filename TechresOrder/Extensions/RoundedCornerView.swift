//
//  RoundedCornerView.swift
//  Techres-Customer
//
//  Created by Kelvin on 11/15/20.
//  Copyright © 2020 aloapp. All rights reserved.
//

import UIKit
import AVKit


class AudioPlayerController: NSObject {
    
    private var player: AVPlayer?
    private var countdownTimer: Timer?
    private var remainingTime: TimeInterval = 0
    private var durationStringUpdateHandler: ((String) -> Void)?
    private var playbackCompletionHandler: (() -> Void)?
    private var isPlaying: Bool = false
    
    func playAudio(from urlString: String, durationStringUpdateHandler: @escaping (String) -> Void, completion: @escaping () -> Void) {
        self.durationStringUpdateHandler = durationStringUpdateHandler
        self.playbackCompletionHandler = completion
        
        // Create AVPlayer
        if let url = URL(string: urlString) {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            
            // Add observer for end of playback
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: nil)
            
            // Start playback
            player?.play()
            isPlaying = true
            
            // Start countdown timer
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                  target: self,
                                                  selector: #selector(updateDuration),
                                                  userInfo: nil,
                                                  repeats: true)
        } else {
            dLog("Invalid URL Or URL Error")
            completion()
        }
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        // Audio playback reached end
        stopAudio()
    }

    @objc private func updateDuration() {
        // Update remaining time and duration string
        if let duration = player?.currentItem?.asset.duration.seconds {
            let currentTime = player?.currentTime().seconds ?? 0
            remainingTime = duration - currentTime
            updateDurationString()
        }
    }

    private func updateDurationString() {
        // Update duration string
        let hours = Int(remainingTime / 3600)
        let minutes = Int((remainingTime.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
        var durationString = ""
        if hours > 0 {
            durationString += String(format: "%02d:", hours)
        }
        durationString += String(format: "%02d:%02d", minutes, seconds)
        durationStringUpdateHandler?(durationString)
    }
    
    func stopAudio() {
        // Stop playback, invalidate timer, and remove observers
        player?.pause()
        isPlaying = false
        // Reset duration time when stop or pause
        if let duration = player?.currentItem?.asset.duration.seconds {
            remainingTime = duration
            countdownTimer?.invalidate()
            countdownTimer = nil
            updateDurationString()
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        // Replace current item with nil to stop audio playback
        player?.replaceCurrentItem(with: nil)
        // Call completion handler after stopping audio
        playbackCompletionHandler?()
    }
    
    func isAudioPlaying() -> Bool {
        return isPlaying
    }
}
