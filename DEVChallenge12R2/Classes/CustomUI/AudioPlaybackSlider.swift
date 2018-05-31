//
//  AudioPlaybackSlider.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/25/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit


class AudioPlaybackSlider: UIView {
    var trackView = UIView()
    var dotView = UIView()
    var progressLayer = CAShapeLayer()

    private var trackColor: UIColor = .lightGray
    private var dotColor: UIColor = .red
    private var progressColor: UIColor = .green


    private var path: UIBezierPath {
        let width: CGFloat = frame.width
        let height: CGFloat = 4.0
        let point = CGPoint(x: 0, y: 0)
        return UIBezierPath(rect: CGRect(x: point.x, y: point.y, width: width, height: height))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addElements()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addElements()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dotView.layer.cornerRadius = dotView.frame.width / 2
        setupProgressLayer()
        trackView.layer.addSublayer(progressLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addElements() {
        setupTrackView()
        setupDotView()
    }

    func setupTrackView() {
        trackView.backgroundColor = trackColor
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.sliderTapped(gestureRecognizer:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        addSubview(trackView)
        trackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(4)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

    }

    func setupProgressLayer() {
        progressLayer.removeFromSuperlayer()
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 1
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.fillColor = progressColor.cgColor
        progressLayer.lineWidth = 1

    }

    func setupDotView() {
        dotView.backgroundColor = dotColor
        trackView.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(15)
            make.width.equalTo(5)
        }
    }

    private func setProgressAnimation(end: CGFloat) {
        print(end)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.5
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = end
        progressLayer.add(animation, forKey: "strokeEndAnimation")
    }



    @objc func sliderTapped(gestureRecognizer: UIPanGestureRecognizer) {
        let locationX = gestureRecognizer.location(in: self).x
        let pointToMove = (trackView.frame.width - locationX) / trackView.frame.width
        if pointToMove >= 1 {
            setProgressAnimation(end: 1.0)
        } else if  pointToMove <= 0 {
            setProgressAnimation(end: 0.0)
        } else {
            setProgressAnimation(end: pointToMove)
        }

    }
    
}
