//
//  AudioHelper.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/30/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import AVFoundation


class AudioHelper {
    static let player = AudioHelper()
    var audioPlayer: AVAudioPlayer?
    var audioTimer: Timer?

    var audioPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("morseTrack.m4a")
    }

    private init() {}

    func playSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }

    func removeAudioFile() {
        try? FileManager.default.removeItem(at: audioPath)
    }
}
