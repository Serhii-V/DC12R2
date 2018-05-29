//
//  DropDownButton.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/28/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class DropDownButton: UIButton {
//    var dropDownView = DropDownView()
//    var height = NSLayoutConstraint()
//    var isOpen = false
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.lightGray
//        dropDownView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        dropDownView.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    override func didMoveToSuperview() {
//        self.superview?.addSubview(dropDownView)
//        self.superview?.bringSubview(toFront: dropDownView)
//        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        dropDownView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        height = dropDownView.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: 0))
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isOpen == false {
//            isOpen = true
//            NSLayoutConstraint.deactivate([self.height])
//            self.height.constant = 150
//            NSLayoutConstraint.activate([self.height])
//
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.dropDownView.layoutIfNeeded()
//                self.dropDownView.center.y += self.dropDownView.frame.height / 2
//            }, completion: nil)
//        } else {
//            isOpen = false
//            NSLayoutConstraint.deactivate([self.height])
//            self.height.constant = 0
//            NSLayoutConstraint.activate([self.height])
//
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.dropDownView.center.y -= self.dropDownView.frame.height / 2
//                self.dropDownView.layoutIfNeeded()
//            }, completion: nil)
//        }
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//    }


}
