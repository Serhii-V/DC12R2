//
//  AudioControlView.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/25/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class AudioControlView: UIView {
    var playPauseButton: UIButton = UIButton()
    var forwardButton: UIButton = UIButton()
    var backwardButton: UIButton = UIButton()
    var playSpeed: UIButton = UIButton()
    var forwardSpeed: UIButton = UIButton()
    var backwardSpeed: UIButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        

    }



}
