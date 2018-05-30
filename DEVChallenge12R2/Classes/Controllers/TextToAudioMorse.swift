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
    var audioPlayer = AudioHelper.player
    let queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 1
    }

    func textViewDidChange(_ textView: UITextView) {
        queue.cancelAllOperations()
        let operation = CreateSoundOperation(inputString: textView.text)
        queue.addOperation(operation)
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        audioPlayer.playSound()
    }


}













