//
//  TextToAudioMorse.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/25/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import AVFoundation


class TextToAudioMorse: UIViewController, UITextViewDelegate, MorseConvertable {
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playSpeedLabel: UILabel!
    @IBOutlet weak var backwardSpeedLabel: UILabel!
    @IBOutlet weak var forwardSpeedLabel: UILabel!

    let timeFormatter = NumberFormatter()
    var audioPlayer = AudioHelper.player
    var audioTimer: Timer?
    let queue = OperationQueue()
    var isDragging = true


    var isNewTrack: Bool = true {
        didSet {
            timeSlider.value = 0.0
            isPlay = !isNewTrack
        }
    }

    var isPlay: Bool = false {
        didSet {
            if isPlay {
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                audioPlayer.isPlaying = isPlay
            } else {
                playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                audioPlayer.isPlaying = isPlay
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        queue.maxConcurrentOperationCount = 1
    }

    func setupUI() {
        hideKeyboardWhenTappedAround()
        inputTextView.layer.cornerRadius = inputTextView.frame.height / 10
        outputTextView.layer.cornerRadius = outputTextView.frame.height / 10
    }

    func textViewDidChange(_ textView: UITextView) {
        outputTextView.text = textToMorseCode(input: textView.text)
        queue.cancelAllOperations()
        let operation = CreateSoundOperation(inputString: textView.text)
        queue.addOperation(operation)
        isNewTrack = true
    }

    func createTimer() {
        if audioTimer != nil {
            audioTimer!.invalidate()
        }
        audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer(timer:)), userInfo: nil, repeats: true)
    }

    @objc func onTimer(timer: Timer) {
        guard let currentTime = audioPlayer.audioPlayer?.currentTime, let duration = audioPlayer.audioPlayer?.duration else {
            return
        }
        print("currentTime: \(currentTime)  duration: \(duration)")
        let mins = currentTime / 60
        let secs = currentTime.truncatingRemainder(dividingBy: 60)
        let percentCompleted = currentTime / duration
        guard let minsStr = timeFormatter.string(from: NSNumber(value: mins)), let secsStr = timeFormatter.string(from: NSNumber(value: secs)) else {
            return
        }
        timeLabel.text = "\(minsStr):\(secsStr)"
        if !isDragging {
            timeSlider.value = Float(percentCompleted)
        }
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        if isNewTrack {
            audioPlayer.createSound()
            createTimer()
            isNewTrack = false
        }
        isPlay = !isPlay
    }

    // MARK: Slider actions
    @IBAction func timeChanged(_ sender: UISlider) {
        guard let player = audioPlayer.audioPlayer else { return }
        player.currentTime = player.duration * Double(sender.value)
    }

    @IBAction func touchDown(_ sender: UISlider) {
        isDragging = true
    }

    @IBAction func touchUp(_ sender: UISlider) {
        isDragging = false
    }

    @IBAction func touchUpOutside(_ sender: UISlider) {
        isDragging = false
    }
}













