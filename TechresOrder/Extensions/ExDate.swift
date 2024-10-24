//
//  ExDate.swift
//  Swift-Extensionn
//
//  Created by Anand Nimje on 27/01/18.
//  Copyright © 2018 Anand. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation


extension Date {
    
    func dateTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func timeAgoDisplay() -> String {
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let secondAgo = Int(Date().timeIntervalSince(self))
        //if less than 60 second -> seccond
        if(secondAgo < minute) {
            return "Vừa xong"
        }
        //if less than 60*60(60 minutes)  -> seccond
        else if (secondAgo < hour) {
            return "\(secondAgo / minute) phút "
        }
        //if less than 60*60*24(24 hours)  -> hour
        else if (secondAgo < day) {
            return "\(secondAgo / hour) giờ "
        }
        //if less than 60*60*24*7(7 day)  -> day
        else if (secondAgo < week) {
            return "\(secondAgo / day) ngày "
        }
        //if less than 60*60*24*7(7 day)  -> day
        else if (secondAgo < month) {
            return "\(secondAgo / week) tuần "
        }
        else if (secondAgo < year) {
            return "\(secondAgo / month) tháng "
        }
        //week
        return "\(secondAgo / year) năm "
    }
    
    func timeAgoToHandle() -> Int {
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let secondAgo = Int(Date().timeIntervalSince(self))
        //if less than 60 second -> seccond
        if(secondAgo < minute) {
            return secondAgo
        }
        //if less than 60*60(60 minutes)  -> seccond
        else if (secondAgo < hour) {
            return (secondAgo / minute)
        }
        //if less than 60*60*24(24 hours)  -> hour
        else if (secondAgo < day) {
            return secondAgo / hour
        }
        //if less than 60*60*24*7(7 day)  -> day
        else if (secondAgo < week) {
            return (secondAgo / day)
        }
        //if less than 60*60*24*7(7 day)  -> day
        else if (secondAgo < month) {
            return (secondAgo / week)
        }
        else if (secondAgo < year) {
            return (secondAgo / month)
        }
        //week
        return (secondAgo / year)
    }
}


extension Date {
    func adding(hour: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hour, to: self)!
    }

    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
      
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }

    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }

    func isSmallerThanOrEqual(_ date: Date) -> Bool {
        return self <= date
    }
    
}
