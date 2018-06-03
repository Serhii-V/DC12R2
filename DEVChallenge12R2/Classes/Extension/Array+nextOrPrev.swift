//
//  Array+nextOrPrev.swift
//  DEVChallenge12R2
//
//  Created by " " on 5/31/18.
//  Copyright © 2018 " ". All rights reserved.
//

import Foundation

extension Array {
    func nextValue(inputValue: Float) -> Float {
        guard let arr = self as? [Float] else { return 0.0 }
        guard let index = arr.index(of: inputValue) else { return 0.0}
        let last = arr.count - 1
        if index == last {
            return arr.first!
        }
        return arr[index + 1]
    }

    func prevValue(inputValue: Float) -> Float {
        guard let arr = self as? [Float] else { return 0.0 }
        guard let index = arr.index(of: inputValue) else {return 0.0}
        if index == 0 {
            return arr.last!
        }
        return arr[index - 1]
    }
}
