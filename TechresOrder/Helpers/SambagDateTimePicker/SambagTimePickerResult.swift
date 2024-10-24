//
//  SambagTimePickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 02/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public struct SambagTimePickerResult {
    
    public var hour: Int
    public var minute: Int
    
    public init() {
        self.hour = 0
        self.minute = 0
    }
}

extension SambagTimePickerResult: CustomStringConvertible {
    
    public var description: String {
        return String(format: "%02d:%02d", hour, minute)
    }
}
