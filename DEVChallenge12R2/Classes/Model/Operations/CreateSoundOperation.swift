//
//  CreateSoundOperation.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/30/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import AVFoundation

protocol SoundOperationDelegate: NSObjectProtocol {
    func startOperation()
    func finishOperation()
}

class CreateSoundOperation: AsyncOperation, MorseConvertable {
    private var morseString: String
    weak var delegate: SoundOperationDelegate?

    init(inputString: String) {
        morseString = inputString
        super.init()
    }

    override func main() {
        if isCancelled { state = .finished; return }
        AudioHelper.player.removeAudioFile()
        let soundFiles = textToSoundCode(input: morseString)
        var startTime: CMTime = kCMTimeZero
        let composition: AVMutableComposition = AVMutableComposition()
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!

        for fileName in soundFiles {
            if isCancelled { state = .finished; return }
            let sound: String = Bundle.main.path(forResource: fileName, ofType: "mp3")!

            let url: URL = URL(fileURLWithPath: sound)
            let avAsset: AVURLAsset = AVURLAsset(url: url)
            let timeRange: CMTimeRange = CMTimeRangeMake(kCMTimeZero, avAsset.duration)
            let audioTrack: AVAssetTrack = avAsset.tracks(withMediaType: .audio).first!

            try! compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: startTime)
            startTime = CMTimeAdd(startTime, timeRange.duration)
        }
        if isCancelled { state = .finished; return }
        let export: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!

        export.outputURL = AudioHelper.player.audioPath
        export.outputFileType = .m4a

        if isCancelled { state = .finished; return }
        export.exportAsynchronously {
            if export.status == .completed {
                self.state = .finished
            }
        }
    }
}
