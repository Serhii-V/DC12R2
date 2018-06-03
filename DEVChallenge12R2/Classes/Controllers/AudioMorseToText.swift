//
//  AudioMorseToText.swift
//  DEVChallenge12R2
//
//  Created by " " on 5/25/18.
//  Copyright © 2018 " ". All rights reserved.
//

import UIKit
import AVFoundation

class AudioMorseToText: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var outputTextView: UITextView!

    var audioPlayer = AudioHelper.player
    var isAudioRecordingGranted: Bool = false
    var rec: Bool = false {
        didSet {
            startStopRec()
        }
    }

    var isPlay: Bool = false {
        didSet {
            if isPlay == true {
                audioPlayer.createSoundByRec()
                audioPlayer.isPlaying = true
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            } else {
                playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                audioPlayer.isPlaying = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        checkRecordPermission()
    }

    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        }
    }

    func setupUi() {
        recButton.layer.cornerRadius = recButton.frame.height / 2
        recButton.layer.masksToBounds = true
        outputTextView.layer.cornerRadius = 10
    }

    func startStopRec() {
        if rec {
            UIView.transition(with: recButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.recButton.setImage(#imageLiteral(resourceName: "activeRecButton"), for: .normal)
            }, completion: nil)
        } else {
            UIView.transition(with: recButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.recButton.setImage(#imageLiteral(resourceName: "inactiveRecButton"), for: .normal)
            }, completion: nil)
        }
    }

    func recordAudio(_ isRecording: Bool) {
        if isRecording {
            RecHelper.shared.startRecording()
            return
        }
        let audioData = RecHelper.shared.stopRecording()
        if audioData != nil {
            let levelsOfSoundWave = RecHelper.shared.getLevelArray()
            print(levelsOfSoundWave)
        }
    }

    // MARK: - Remove if i make progress with convertation
    func showPurchaseAlert() {
        let alertController = UIAlertController(title: "Upgrate to Pro", message: "If You wanna use Pro version, subscribe please. Only 10$ per day :)))", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Pay Now", style: .default, handler: { _ in
            self.apologise()
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    func apologise() {
        let alertController = UIAlertController(title: "", message: "It's a joke, I haven't done this part :(((", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Forgive", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func levelsToMorseCode() {
        let array = RecHelper.shared.getLevelArray()
        var bitCodeArray: [Int] = [Int]()
        var max = array.first!
        var min = array.first!
        for i in array {
            if i > max {
                max = i
            }
            if i < min {
                min = i
            }
        }
        let avarange = (min + max) / 2

        for i in array {
            if i > avarange {
                bitCodeArray.append(0)
            } else {
                bitCodeArray.append(1)
            }
        }
    }

    @IBAction func recButtonPressed(_ sender: UIButton) {
        if rec {
            recordAudio(false)
        } else {
            recordAudio(true )
        }
        rec = !rec
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        isPlay = !isPlay
    }

    @IBAction func convertButtonTapped(_ sender: UIButton) {
        levelsToMorseCode()
        showPurchaseAlert()
    }


}
