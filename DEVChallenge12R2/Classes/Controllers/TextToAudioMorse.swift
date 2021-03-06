//
//  TextToAudioMorse.swift
//  DEVChallenge12R2
//
//  Created by " " on 5/25/18.
//  Copyright © 2018 " ". All rights reserved.
//

import UIKit
import AVFoundation


class TextToAudioMorse: UIViewController, UITextViewDelegate, MorseConvertable {
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playSpeedLabel: UILabel!
    @IBOutlet weak var backwardSpeedLabel: UILabel!
    @IBOutlet weak var forwardSpeedLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!


    let timeFormatter = NumberFormatter()
    var audioPlayer = AudioHelper.player
    var audioTimer: Timer?
    let queue = OperationQueue()
    var spinner: Spinner = Spinner()
    var isDragging = false
    private let playSpeedArray: [Float] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
    private let speedArray: [Float] = [5.0, 10.0, 30.0]

    var forwardSpeed: Float = 5.0 {
        didSet{
            forwardSpeedLabel.text = "\(Int(forwardSpeed))" + "s"
        }
    }

    var backwardSpeed: Float = 5.0 {
        didSet {
            backwardSpeedLabel.text = "\(Int(backwardSpeed))" + "s"
        }
    }

    var playSpeed: Float = 1.0 {
        didSet {
            if playSpeed == 1.0 {
                playSpeedLabel.text = "normal"
            } else {
                playSpeedLabel.text = "\(playSpeed)" + "x"
            }
        }
    }

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
        buttonAddGesture()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
    }

    override func viewDidAppear(_ animated: Bool) {
        if Storage.isFirstEnter() {
            showInfo()
            Storage.firstEnterDone()
        }
    }

    func setupUI() {
        hideKeyboardWhenTappedAround()
        inputTextView.layer.cornerRadius = inputTextView.frame.height / 10
        inputTextView.contentInset.top = 1
        outputTextView.layer.cornerRadius = outputTextView.frame.height / 10
        timeSlider.isUserInteractionEnabled = false
    }

    func textViewDidChange(_ textView: UITextView) {
        audioPlayer.audioPlayer?.currentTime = 0.0
        spinner.start()
        audioPlayer.removeAudioFile()
        outputTextView.text = textToMorseCode(input: textView.text)
        queue.cancelAllOperations()
        let operation = CreateSoundOperation(inputString: textView.text)
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.spinner.stop()
            }
        }
        if textView.text == "" {
            spinner.stop()
        }
        queue.addOperation(operation)
        isPlay = false
        isNewTrack = true
    }

    func showInfo() {
        let alertController = UIAlertController(title: "Tutorial", message: "", preferredStyle: .alert)
        let image = #imageLiteral(resourceName: "info")
        alertController.addImage(image)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func showEmptyAlert() {
        let alertController = UIAlertController(title: "Please, input text", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - keyboard and scrollview
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        scrollView.bounces = true
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }

    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.bounces = false
    }

    // MARK: - Timer setup
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
        if currentTime == 0.0 {
            isPlay = false
        }
    }

    // MARK: - Button speed setup
    func buttonAddGesture() {
        let playPauseButtonGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(speedUpPlay(sender:)))
        playPauseButtonGestureRight.direction = .right
        let playPauseButtonGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(speedDownPlay(sender:)))
        playPauseButtonGestureLeft.direction = .left
        let forwardButtonGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(speedUpForward(sender:)))
        forwardButtonGestureRight.direction = .right
        let forwardButtonGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(speedDownForward(sender:)))
        forwardButtonGestureLeft.direction = .left
        let backwardButtonGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(speedDownBackward(sender:)))
        backwardButtonGestureRight.direction = .right
        let backwardButtonGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(speedUpBackward(sender:)))
        backwardButtonGestureLeft.direction = .left

        backwardButton.addGestureRecognizer(backwardButtonGestureRight)
        forwardButton.addGestureRecognizer(forwardButtonGestureRight)
        playPauseButton.addGestureRecognizer(playPauseButtonGestureRight)
        backwardButton.addGestureRecognizer(backwardButtonGestureLeft)
        forwardButton.addGestureRecognizer(forwardButtonGestureLeft)
        playPauseButton.addGestureRecognizer(playPauseButtonGestureLeft)
    }

    @objc func speedUpPlay(sender: UIGestureRecognizer) {
        playSpeed = playSpeedArray.nextValue(inputValue: playSpeed)
        audioPlayer.changeSpeed(speed: playSpeed)
    }
    @objc func speedUpForward(sender: UIGestureRecognizer) {
        forwardSpeed = speedArray.nextValue(inputValue: forwardSpeed)
    }
    @objc func speedUpBackward(sender: UIGestureRecognizer) {
        backwardSpeed = speedArray.nextValue(inputValue: backwardSpeed)
    }

    @objc func speedDownPlay(sender: UIGestureRecognizer) {
        playSpeed = playSpeedArray.prevValue(inputValue: playSpeed)
        audioPlayer.changeSpeed(speed: playSpeed)
    }

    @objc func speedDownForward(sender: UIGestureRecognizer) {
        forwardSpeed = speedArray.prevValue(inputValue: forwardSpeed)
    }

    @objc func speedDownBackward(sender: UIGestureRecognizer) {
        backwardSpeed = speedArray.prevValue(inputValue: backwardSpeed)
    }

    // MARK: - Button tapped
    @IBAction func playPauseTapped(_ sender: UIButton) {
        if inputTextView.text == "" {
            showEmptyAlert()
        } else {
        if isNewTrack {
            audioPlayer.createSound()
            audioPlayer.changeSpeed(speed: playSpeed)
            createTimer()
            isNewTrack = false
            timeSlider.isUserInteractionEnabled = true
            isPlay = !isPlay
        }
        isPlay = !isPlay
        }
    }

    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        audioPlayer.changeTrackPosition(interval: forwardSpeed)
    }

    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        audioPlayer.changeTrackPosition(interval: -backwardSpeed)
    }

    @IBAction func infoButttonTapped(_ sender: UIButton) {
        showInfo()
    }

    // MARK: - Slider actions
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














