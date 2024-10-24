//
//  SambagYearPickerResult.swift
//  Techres-Seemt
//
//  Created by macmini_techres_04 on 19/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import Foundation

public struct SambagYearPickerResult {

    public var year: Int
    public var asDate: Date? {
        var dateComps = DateComponents()
        dateComps.year = year
        return Calendar.current.date(from: dateComps)
    }
    public init() {
        self.year = 0
    }
}

extension SambagYearPickerResult: CustomStringConvertible {
    
    public var description: String {
        return "\(year)"
    }
}

extension SambagYearPickerResult: Equatable {
    
    public static func ==(lhs: SambagYearPickerResult, rhs: SambagYearPickerResult) -> Bool {
        return  lhs.year == rhs.year
    }
}

public protocol SambagYearPickerResultValidator {
    
    func isValidResult(_ result: SambagYearPickerResult) -> Bool
}

extension SambagYearPickerResult {
    
    public class Validator: SambagYearPickerResultValidator {
        
        var formatter: DateFormatter
        
        init(dateFormat: String = "yyyy") {
            self.formatter = DateFormatter()
            self.formatter.dateFormat = dateFormat
        }
        
        public func isValidResult(_ result: SambagYearPickerResult) -> Bool {
            return formatter.date(from: "\(result)") != nil
        }
    }
}

public protocol SambagYearPickerResultSuggestor {
    
    func suggestedResult(from result: SambagYearPickerResult) -> SambagYearPickerResult
}

extension SambagYearPickerResult {
    
    public class Suggestor: SambagYearPickerResultSuggestor {
        
        var validator: SambagYearPickerResultValidator
     
        
        init(validator: SambagYearPickerResultValidator = SambagYearPickerResult.Validator()) {
            self.validator = validator
        }
        
        public func suggestedResult(from result: SambagYearPickerResult) -> SambagYearPickerResult {
           
            
            guard !validator.isValidResult(result) else {
                return result
            }
            
            
            return result
        }
        
        func isLeapYear(_ year: Int) -> Bool {
            return (year % 100 != 0 && year % 4 == 0) || year % 400 == 0
        }
    }
}


