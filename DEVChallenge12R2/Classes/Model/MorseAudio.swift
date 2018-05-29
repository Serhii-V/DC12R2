//
//  MorseHendler.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import AVFoundation


class MorseAudio: NSObject {
    private let fileManager = FileManager.default
    private var morseString: String

    private var audioPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("morseTrack.m4a")
    }

    init(inputMorseString: String) {
        morseString = inputMorseString
    }

    private let morseDict: Dictionary = [ "A": ". -",
                                        "B": "- . . .",
                                        "C": "- . - .",
                                        "D": "- . .",
                                        "E": ".",
                                        "F": ". . - .",
                                        "G": "- - .",
                                        "H": ". . . .",
                                        "I": ". .",
                                        "J": ". - - -",
                                        "K": "- . -",
                                        "L": ". - . .",
                                        "M": "- -",
                                        "N": "- .",
                                        "O": "- - -",
                                        "P": ". - - .",
                                        "Q": "- - . -",
                                        "R": ". - .",
                                        "S": ". . .",
                                        "T": "-",
                                        "U": ". . -",
                                        "V": ". . . -",
                                        "W": ". - -",
                                        "X": "- . . -",
                                        "Y": "- . - -",
                                        "Z": "- - . .",
                                        "1": ". - - - -",
                                        "2": ". . - - -",
                                        "3": ". . . - -",
                                        "4": ". . . . -",
                                        "5": ". . . . .",
                                        "6": "- . . . .",
                                        "7": "- - . . .",
                                        "8": "_ _ _ . .",
                                        "9": "- - - - .",
                                        "0": "- - - - -",
                                        " ": "    "]

    func textToCode(str: String) -> String {
        let inputStr: String = str.uppercased()
        var outputString: String = String()

        for i in inputStr {
            guard let transformed = morseDict["\(i)"] else { print("error can not transform \(i)"); continue }
            outputString += transformed + "   "
        }
        return outputString
    }

    func textToSound() -> [String] {
        let morseCode = textToCode(str: morseString)
        var soundArray: [String] = []

        for i in morseCode {
            switch i {
            case " ":
                soundArray.append("silent")
            case ".":
                soundArray.append("dot")
            case "-":
                soundArray.append("dash")
            default:
                continue
            }
        }
        return soundArray
    }
    
    private func createSound(completion: @escaping ()->()) {
//        removeAudioFile()
        let soundFiles = textToSound()
        var startTime: CMTime = kCMTimeZero
        let composition: AVMutableComposition = AVMutableComposition()
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!

        for fileName in soundFiles {
            let sound: String = Bundle.main.path(forResource: fileName, ofType: "mp3")!

            let url: URL = URL(fileURLWithPath: sound)
            let avAsset: AVURLAsset = AVURLAsset(url: url)
            let timeRange: CMTimeRange = CMTimeRangeMake(kCMTimeZero, avAsset.duration)
            let audioTrack: AVAssetTrack = avAsset.tracks(withMediaType: .audio)[0]

            try! compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: startTime)
            startTime = CMTimeAdd(startTime, timeRange.duration)
        }

        let export: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!

        export.outputURL = audioPath
        export.outputFileType = .m4a

        export.exportAsynchronously (completionHandler: {
//            if export.status == .completed {
//                print(self.audioPath.absoluteString)
//                print(self.fileManager.fileExists(atPath: self.audioPath.absoluteString))
                completion()
//            }
        })
    }

    func playSound() {
        print("xxx")
        print(String(validatingUTF8: __dispatch_queue_get_label(nil)))
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                print(self.fileManager.fileExists(atPath: self.audioPath.absoluteString))
                print(self.audioPath)
                let audioPlayer = try AVAudioPlayer(contentsOf: self.audioPath)
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch (let error) {
                print("aPlayer error  \(error.localizedDescription)")
            }
    }

    func play() {
        createSound {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.playSound()
            })
        }
    }

    private func removeAudioFile() {
        try? FileManager.default.removeItem(at: audioPath)
    }
}

extension MorseAudio: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("HELLO")
        print(flag)
    }
}
