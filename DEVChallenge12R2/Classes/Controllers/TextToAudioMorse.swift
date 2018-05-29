//
//  TextToAudioMorse.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/25/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import AVFoundation


class TextToAudioMorse: UIViewController, UITextViewDelegate {
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var playPauseButton: UIButton!
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textViewDidChange(_ textView: UITextView) {

    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        let morseAudio: MorseAudio = MorseAudio(inputMorseString: inputTextView.text)
        morseAudio.play()
    }


}













