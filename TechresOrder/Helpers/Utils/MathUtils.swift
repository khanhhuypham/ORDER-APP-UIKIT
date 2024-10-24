//
//  MathUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/01/2024.
//

import UIKit

class MathUtils: NSObject {
    static func isInteger(number: Double) -> Bool {
        return floor(number) == number
    }
    
    static func isInteger(number: Float) -> Bool {
        return floor(number) == number
    }
//
//    static func convertStringToNumber(str:String) -> NSNumber{
//            
//        var text = str
//
//        if let firstComma = text.firstIndex(of: ",") {
//         
//            let index = str.index(firstComma, offsetBy: 1)
//            
//            for i in str.indices[index..<str.endIndex] {
//                if str[i] == ","{
//                    text.remove(at: i)
//                }
//            }
//        }
//        
//        
//        let formatter = NumberFormatter()6
//        // Convert the string to an NSNumber
//        if let number = formatter.number(from: str) {
//          
//            let typeEncoding = String(cString: number.objCType)
//   
//            /*
//             
//             // Determine the type of number
//             if typeEncoding == "c" {
//                 print("The number is of type char.")
//             } else if typeEncoding == "i" {
//                 print("The number is of type int.")
//             } else if typeEncoding == "s" {
//                 print("The number is of type short.")
//             } else if typeEncoding == "l" {
//                 print("The number is of type long.")
//             } else if typeEncoding == "q" {
//                 print("The number is of type long long.")
//             } else if typeEncoding == "C" {
//                 print("The number is of type unsigned char.")
//             } else if typeEncoding == "I" {
//                 print("The number is of type unsigned int.")
//             } else if typeEncoding == "S" {
//                 print("The number is of type unsigned short.")
//             } else if typeEncoding == "L" {
//                 print("The number is of type unsigned long.")
//             } else if typeEncoding == "Q" {
//                 print("The number is of type unsigned long long.")
//             } else if typeEncoding == "f" {
//                 print("The number is of type float.")
//             } else if typeEncoding == "d" {
//                 print("The number is of type double.")
//             } else if typeEncoding == "B" {
//                 print("The number is of type C++ bool or Objective-C BOOL.")
//             } else {
//                 print("Unknown type.")
//             }
//             */
//            
//        }
//
//            
//
//        let maybeNumber = formatter.number(from: text)
//        return maybeNumber ?? NSNumber(value: 0)
//    }
    
 
    
    static func convertToMoney(integer:Int? = nil,float:Float? = nil, double:Double? = nil , unit_name :String = "") -> String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        return ""
        
    }
    
    

    
    static func convertStringToDoubleString(str:String) -> String{
        
        var result = str.replacingOccurrences(of: ",", with: ".")
        
        
        if let firstDot = result.firstIndex(of: ".") {

            let index = result.index(firstDot, offsetBy: 1)

            for i in result.indices[index..<result.endIndex] {
                if result[i] == "."{
                    result.remove(at: i)
                }
            }
            
        }
        
        
        if let lastDot = result.lastIndex(where: {$0 == "."}){

            if result[lastDot...].count > 3 {
                let index = str.index(lastDot, offsetBy: 3)
                result.removeSubrange(index..<result.endIndex)
            }
            
        }
        
        return result
    }
        
    

    

    
    
}
