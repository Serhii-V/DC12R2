//
//  Storage.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 6/1/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation

class Storage {
    static func isFirstEnter() -> Bool {
        if isFirstEnterPresentInStorage() {
            return true
        }
        return UserDefaults.standard.bool(forKey: "firstEnter")
    }

   static func firstEnterDone() {
        UserDefaults.standard.set(false, forKey: "firstEnter")
    }

    private static func isFirstEnterPresentInStorage() -> Bool {
        return UserDefaults.standard.object(forKey: "firstEnter") == nil
    }
    
    private init() {}
}
