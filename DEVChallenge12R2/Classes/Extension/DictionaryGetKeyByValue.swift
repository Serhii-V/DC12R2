//
//  DictionaryGetKeyByValue.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/27/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation


extension Dictionary where Value: Equatable {
    func getKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
    
}
