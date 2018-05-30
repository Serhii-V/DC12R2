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
    private var dotColor: UIColor = .black
    private var progressColor: UIColor = .darkGray

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addElements()


    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addElements() {
        trackView.backgroundColor = trackColor
        dotView.backgroundColor = dotColor
        progressLayer.fillColor = progressColor.cgColor
        addSubview(trackView)
        addSubview(dotView)
        trackView.layer.addSublayer(progressLayer)

        



        


        
        

        


    }
    
}
