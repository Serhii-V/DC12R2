//
//  UIViewController+HideKeyBoard.swift
//  DEVChallenge12R2
//
//  Created by " " on 5/31/18.
//  Copyright © 2018 " ". All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
