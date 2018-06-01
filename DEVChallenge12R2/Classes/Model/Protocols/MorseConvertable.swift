//
//  MorseConvertable.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/30/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

protocol MorseConvertable: NSObjectProtocol {
    var morseDict: [String: String] { get }
    func textToMorseCode(input: String) -> String
    func textToSoundCode(input: String) -> [String]
}

extension MorseConvertable {
    var morseDict: [String: String] {
        return [ "A": ". -",
                 "B": "- . . .",
                 "C": "- . - .",
                 "D": "- . .",
                 "E": ".",
                 "F": ". . - .",
                 "G": "- - .",
                 "H": ". . . .",
                 "I": ". .",
                 "J": ". - - -",
                 "K": "- . -",
                 "L": ". - . .",
                 "M": "- -",
                 "N": "- .",
                 "O": "- - -",
                 "P": ". - - .",
                 "Q": "- - . -",
                 "R": ". - .",
                 "S": ". . .",
                 "T": "-",
                 "U": ". . -",
                 "V": ". . . -",
                 "W": ". - -",
                 "X": "- . . -",
                 "Y": "- . - -",
                 "Z": "- - . .",
                 "1": ". - - - -",
                 "2": ". . - - -",
                 "3": ". . . - -",
                 "4": ". . . . -",
                 "5": ". . . . .",
                 "6": "- . . . .",
                 "7": "- - . . .",
                 "8": "_ _ _ . .",
                 "9": "- - - - .",
                 "0": "- - - - -",
                 " ": "    "]
    }

    func textToMorseCode(input: String) -> String {
        let inputStr: String = input.uppercased()
        var outputString: String = String()

        for i in inputStr {
            guard let transformed = morseDict["\(i)"] else { print("error can not transform \(i)"); continue }
            outputString += transformed + "   "
        }
        return outputString
    }

    func textToSoundCode(input: String) -> [String] {
        let morseCode = textToMorseCode(input: input)
        var soundArray: [String] = []

        for i in morseCode {
            switch i {
            case " ":
                soundArray.append("silent")
            case ".":
                soundArray.append("dot")
            case "-":
                soundArray.append("dash")
            default:
                continue
            }
        }
        return soundArray
    }
}
