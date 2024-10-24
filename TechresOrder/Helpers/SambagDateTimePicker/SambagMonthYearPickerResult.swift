//
//  SambagMonthYearPickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 03/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public struct SambagMonthYearPickerResult {

    public var month: SambagMonth
    public var year: Int
    
    public init() {
        self.month = .january
        self.year = 0
    }
}

extension SambagMonthYearPickerResult: CustomStringConvertible {
    
    public var description: String {
        return String(format: "%02d/%d", month.rawValue, year)
    }
}

public enum SambagMonth: Int {
    
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

extension SambagMonth: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .january: return "01"
        case .february: return "02"
        case .march: return "03"
        case .april: return "04"
        case .may: return "05"
        case .june: return "06"
        case .july: return "07"
        case .august: return "08"
        case .september: return "09"
        case .october: return "10"
        case .november: return "11"
        case .december: return "12"
        }
    }
}
