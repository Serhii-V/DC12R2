//
//  RecHelper.swift
//  DEVChallenge12R2
//
//  Created by " " on 6/3/18.
//  Copyright © 2018 " ". All rights reserved.
//

import AVFoundation

class RecHelper: NSObject {
    static let shared = RecHelper()

    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var player: AVAudioPlayer?
    private let encoderBitRate: Int = 320000
    private let numberOfChannels: Int = 1
    private let sampleRate: Double = 12000
    private let audioVisualizationTimeInterval: TimeInterval =  0.1
    private var audioMeteringLevelTimer: Timer?
    private var levelArray: [Int]?

    var recPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("recTrack.m4a")
    }

    func startRecording() {
        setupRecorder() { self.rec() }
    }


    private func setupRecorder(completion: (()->())?=nil) {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { /*[unowned self]*/ allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        print("failed to record")
                    } else {
                        completion?()
                    }
                }
            }
        } catch {
            print("failed to record")
        }
    }

    private func rec() {
        levelArray = [Int]()
        AudioServicesPlaySystemSound(1117)
        let settings: [String : Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: numberOfChannels,
            AVSampleRateKey : sampleRate,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            removeTempItem()
            audioRecorder = try AVAudioRecorder(url: recPath, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()

            audioMeteringLevelTimer = Timer.scheduledTimer(timeInterval: audioVisualizationTimeInterval, target: self,
                                                           selector: #selector(timerDidUpdateMeter),
                                                           userInfo: nil,
                                                           repeats: true)
        } catch {
            print("failed to record")
            print("Error: \(error.localizedDescription)")
            print("Error: \(error)")
            finishRecording(success: false)
        }
    }

    private func removeTempItem() {
        try? FileManager.default.removeItem(at: recPath)
    }

    func finishRecording(success: Bool) {
        guard audioRecorder != nil else { return }
        AudioServicesPlaySystemSound(1118)
        audioRecorder.stop()
        audioRecorder = nil
        stopPlaying()
    }

    var isPlaying: Bool {
        return player != nil
    }

    var isRecording: Bool {
        return audioRecorder != nil
    }

    @objc private func timerDidUpdateMeter() {
        var averagePower: Float


        if isRecording {
            audioRecorder!.updateMeters()
            averagePower = audioRecorder!.averagePower(forChannel: 0)
            levelArray?.append(abs(Int(averagePower)))
        } else if self.isPlaying {
            player!.updateMeters()
            averagePower = player!.averagePower(forChannel: 0)
        } else { audioMeteringLevelTimer?.invalidate(); return }

        let percentage: Float = pow(10, (0.05 * averagePower))
        NotificationCenter.default.post(name: .audioPlayerManagerMeteringLevelDidUpdateNotification, object: self, userInfo: [audioPercentageUserInfoKey: percentage])
    }

    func stopPlaying() {
        audioMeteringLevelTimer?.invalidate()
        audioMeteringLevelTimer = nil
    }

    func getLevelArray() -> [Int] {
            return levelArray!
    }

    @discardableResult
    func stopRecording() -> Data? {
        finishRecording(success: true)
        let data = try? Data(contentsOf: recPath)
        return data
    }    
}

extension RecHelper: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: .audioPlayerManagerMeteringLevelDidFinishNotification, object: self)
    }
}

extension Notification.Name {
    static let audioPlayerManagerMeteringLevelDidUpdateNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidUpdateNotification")
    static let audioPlayerManagerMeteringLevelDidFinishNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidFinishNotification")
}

let audioPercentageUserInfoKey = "percentage"
